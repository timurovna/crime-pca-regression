#Loading data
crime_data <- read.table("uscrime.txt", header=TRUE)
X <- crime_data[, 1:15]
y <- crime_data[, 16] 

#Running PCA on the matrix of scaled predictors
pca_results <- prcomp(crime_data[,1:15], scale. = TRUE)
print(pca_results)
print(summary(pca_results))

#Adding a scree plot to decide how many PCs to use
screeplot(pca_results, type="lines", col="blue")

#Getting first four principal components
pc4 <- pca_results$x[,1:4, drop=FALSE]
colnames(pc4) <- paste0("PC", 1:4)
print(pc4)

#Running linear regression function with four principal components
lm_modelPCA <- lm(y~., data=as.data.frame(pc4))
summary(lm_modelPCA)
print(summary(lm_modelPCA))
qqnorm(residuals(lm_modelPCA))

#Converting back to original variables: Crime = alpha + sum_j gamma_j * X_j
a <- coef(lm_modelPCA)[1]                          
b <- coef(lm_modelPCA)[paste0("PC", 1:4)]          
V <- pca_results$rotation[, 1:4, drop = FALSE]
mu <- pca_results$center                           # means of original X (length 15)
s  <- pca_results$scale                            # sds of original X (length 15)

w <- as.vector(V %*% b)        # contribution back to scaled X (length 15)
gamma <- w / s                  # coefficients for ORIGINAL X (length 15)
alpha <- a - sum(gamma * mu)    # intercept on ORIGINAL scale

coef_orig <- c("(Intercept)" = alpha)
coef_orig <- c(coef_orig, setNames(gamma, colnames(X)))
# our model in original variables
print(coef_orig)
# (Intercept)                       M                      So                      Ed                     Po1 
# 1666.4846379             -16.9307630              21.3436771              12.8297238              21.3521593 
# Po2                      LF                     M.F                     Pop                      NW 
# 23.0883154            -346.5657125              -8.2930969               1.0462155               1.5009941 
# U1                      U2                  Wealth                    Ineq                    Prob 
# -1509.9345216               1.6883674               0.0400119              -6.9020218             144.9492678 
# Time 
# -0.9330765 


#Predicting for the new city directly on original scale
new_city <- data.frame(
  M = 14.0, So = 0, Ed = 10.0, Po1 = 12.0, Po2 = 15.5,
  LF = 0.640, M.F = 94.0, Pop = 150, NW = 1.1, U1 = 0.120,
  U2 = 3.6, Wealth = 3200, Ineq = 20.1, Prob = 0.04, Time = 39.0
)
new_city <- new_city[, colnames(X), drop = FALSE]
pc_new <- as.matrix( scale(new_city, center=mu, scale=s) ) %*% V
colnames(pc_new) <- paste0("PC", 1:4)
pred <- predict(lm_modelPCA, newdata=as.data.frame(pc_new), interval="prediction")
print(pred)
# fit      lwr      upr
# 1112.678 396.1274 1829.228


#Doing 4 fold cross validation to check the quality of our model and to make a comparison
library(caret)
set.seed(42)
folds <- createFolds(crime_data$Crime, k = 4, returnTrain = TRUE)
ctrl  <- trainControl(method="cv", number=4, index=folds, savePredictions="final")

fit_pcr4 <- train(Crime ~ ., data = crime_data,
                  method = "lm",
                  preProcess = c("zv","center","scale","pca"),
                  preProcOptions = list(pcaComp = 4),
                  trControl = ctrl)
print(fit_pcr4$results)
# intercept    RMSE  Rsquared      MAE   RMSESD RsquaredSD    MAESD
# 1      TRUE 268.072 0.5252975 203.4653 54.19728  0.2355872 27.69035
