# crime-pca-regression

Crime Rate Prediction Using Principal Component Regression (PCR)

Repository Description (short GitHub blurb)

Applied Principal Component Analysis (PCA) and regression modeling on socio-economic crime data to reduce multicollinearity, improve prediction stability, and compare out-of-sample performance against standard linear regression.

Project Overview

This project applies Principal Component Analysis (PCA) and linear regression to predict crime rates using socio-economic and demographic variables from U.S. cities. The primary objective is to address multicollinearity among predictors and improve model generalization performance compared to a standard multiple regression model.

The analysis demonstrates how dimensionality reduction can stabilize regression models in small, high-dimensional datasets.

Examples of predictors:

Education
Population
Income inequality
Police expenditure
Unemployment measures
Probability-related variables


Methodology

1. Data Preparation
Loaded crime dataset and separated:
Predictor matrix (X)
Response variable (y)
Standardized predictors before PCA to ensure equal variable contribution

3. Principal Component Analysis (PCA)

PCA was applied using prcomp() with scaling enabled.

Objectives:
Reduce dimensionality
Remove multicollinearity
Create stable, uncorrelated predictors
Component Selection

A scree plot was used to identify the optimal number of components.

Clear elbow observed around PC4
First 4 principal components selected for modeling
3. Principal Component Regression

A linear regression model was built using:

PC1
PC2
PC3
PC4

Residual diagnostics and QQ plots were used to evaluate model assumptions.

4. Transforming Back to Original Variables

To improve interpretability, regression coefficients were transformed back into the original feature space using:

PCA rotation matrix
Scaling adjustments
Original feature means and standard deviations

This produced a final regression equation directly interpretable in terms of the original socio-economic variables.

5. Model Validation

Model performance was evaluated using:

Prediction intervals
Residual diagnostics
4-fold cross-validation

Metrics reported:

RMSE
MAE
Cross-validated R²

Results

PCA Regression Model

Metric	Value

RMSE	~268

MAE	~203

Cross-validated R²	~0.53

Prediction for new city	~1113

95% prediction interval:

[396, 1829]

Comparison vs Standard Linear Regression

Metric	PCA Regression	Standard Regression

CV R²	~0.53	~0.35


Key Insights

PCA successfully reduced 15 correlated predictors into 4 stable components.
Dimensionality reduction improved out-of-sample predictive performance.
Standard regression showed clear signs of overfitting due to:
small sample size (47 observations)
large number of correlated predictors
PCA regression produced more realistic and stable predictions for new observations.
Cross-validation demonstrated substantially better generalization performance compared to the original regression model.

Conclusion

Principal Component Regression significantly improved model stability and out-of-sample performance compared to standard linear regression. By compressing correlated predictors into a smaller set of orthogonal components, the model reduced overfitting and produced more reliable predictions for unseen data.
