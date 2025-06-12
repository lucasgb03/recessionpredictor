library(readr)
library(lubridate)
library(dplyr)

# Load data
df <- read_csv("recessionpredictors.csv")
df$date <- mdy(df$date)

#Create variables
df$yieldcurve <- df$gs10 - df$gs3m
df$unratelag1 <- dplyr::lag(df$unrate, 1)
df$cpiyoy <- (df$cpi / dplyr::lag(df$cpi,12)-1)*100
df$m2yoy <- (df$m2 / dplyr::lag(df$m2,12)-1)*100
df$recession <- as.factor(df$rec)
df$yieldcurvelag6 <- dplyr::lag(df$yieldcurve, 6)

# Drop missing rows
df <- na.omit(df)

# Run logistic regression
fit1 <- glm(recession ~ yieldcurvelag6*cpiyoy + unratelag1 + m2yoy,
             data = df,family = binomial(link = "logit"))
summary(fit1)
odds_ratios <- exp(coef(fit1))
odds_ratios


discuss1 <- c('From the summary statistics, I can conclude that a 1-unit increase 
              (steepening) in the yield curve (lagged 6 months) is associated with 
              a 4× increase in the odds of a recession. A 1-point increase in CPI YoY 
              is associated with a 3× increase in recession odds. However, a simultaneous 
              1-point increase in both CPI YoY and the yield curve results in a 50% reduction 
              in the odds of a recession (odds ratio ≈ 0.5), indicating an interaction 
              effect. A 1-point increase in the money supply (M2 YoY) is associated with a 
              1.16× increase in the odds of recession. These effects are all statistically 
              significant at the p < 0.005 level. The lagged unemployment rate does not 
              significantly affect recession probability in this model.')

#prediction using todays data
today_input <- data.frame(
  yieldcurvelag6 = -0.62,  # 10y - 3m from 6 months ago
  unratelag1 = 4.2,         # unemployment rate last month
  cpiyoy = 2.33,             # latest YoY CPI %
  m2yoy = 4.44               # latest YoY M2 %
)

p.rec <- predict(fit1, newdata = today_input, type = "response")

#LLR test
fit.null <- glm(recession ~ 1, data=df, family=binomial(link='logit'))
ts <- as.double(2*(logLik(fit1) - logLik(fit.null)))
pvalue <- pchisq(ts, 4, lower.tail=F)

# Predict recession probabilities
df$recession_prob <- predict(fit1, type = "response")

# Plot predicted probability vs actual recession
ggplot(df, aes(x = date)) +
  geom_line(aes(y = recession_prob), color = "blue", linewidth = 1) +
  geom_step(aes(y = as.numeric(as.character(recession))), color = "red", linetype = "dashed", alpha = 0.5) +
  labs(title = "Predicted Recession Probability vs. Actual Recession",
       x = "Date", y = "Recession Probability (blue) / Actual Recession (red)")