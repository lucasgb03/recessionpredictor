# Recession Predictor
## Overview
- A logistic regression model estimating the probability of a U.S. recession based on the lagged yield curve, inflation, money supply growth, and unemployment, using economic data from 1982 to 2025.
- Tools Used: R, FRED Economic Data, ggplot2
- Data: Monthly, from 01/01/1982 to 04/01/2025
- Data Modifications: yieldcurvelag6 = (gs10 - gs3m), lagged 6 months to reflect delayed effects on recession odds; unratelag1 = unemployment rate lagged one month to reflect delayed effects on recession odds; cpiyoy = cpi change over last 12 months; m2yoy = change in money supply over last 12 months
  
## Methodology
- Used glm function for a logit model regressing recession (1/0) on yieldcurvelag6, unratelag1, cpiyoy, m2yoy, and an interaction of yieldcurvelag6*cpiyoy
- Plotted actual recession data (1/0) vs my model's predicted recession outcome
- Transformed coefficients on variables from log odds form to odds form using exp function, enabling easier interpetation
  
## Key Findings
- 1-unit increase (steepening) in the yield curve (lagged 6 months) is associated with a 4× increase in the odds of a recession
- A 1-point increase in CPI YoY is associated with a 3× increase in recession odds
- A simultaneous 1-point increase in both CPI YoY and the yield curve results in a 50% reduction in the odds of a recession (odds ratio ≈ 0.5), indicating an interaction effect
- A 1-point increase in the money supply (M2 YoY) is associated with a 1.16× increase in the odds of recession. This may idnicate that expansionary monetary policy to incentivize spending may precede a recession
- These effects are all statistically significant at the p < 0.005 level.

## Files
- RecessionPredictedvsActual.png
- recessionmodel.R
- recessionpredictors.csv
