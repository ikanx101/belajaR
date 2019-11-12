rm(list=ls())

#Contoh Random Forest
data = mtcars
data

#bangun modelnya
library(randomForest)
fit <- randomForest(am ~ vs + gear + carb + cyl,   data=data)
print(fit) # view results 
importance(fit) # importance of each predictor

#untuk predict
testPred=predict(fit, newdata=data, type = "response")