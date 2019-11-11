rm(list=ls())
library(caret)
library(pROC)
setwd("D://caret_belajar")

#######################################################################
# Import dataset
orange <- read.csv('jeruk.csv')
# Structure of the dataframe
str(orange)
# See top 6 rows and 10 columns
head(orange[, 1:10])
#######################################################################
# Create the training and test datasets
set.seed(100)
# Step 1: Get row numbers for the training data
trainRowNumbers <- createDataPartition(orange$Purchase, p=0.8, list=FALSE)
# Step 2: Create the training  dataset
trainData <- orange[trainRowNumbers,]
# Step 3: Create the test dataset
testData <- orange[-trainRowNumbers,]
#######################################################################
# Descriptive Statistics
library(skimr)
skimmed <- skim_to_wide(trainData)
skimmed[, c(1:5, 9:11, 13, 15:16)]
#######################################################################
# How to impute missing values
# Create the knn imputation model on the training data
preProcess_missingdata_model <- preProcess(trainData, method='knnImpute')
preProcess_missingdata_model
# Use the imputation model to predict the values of missing data points
library(RANN)  # required for knnInpute
trainData <- predict(preProcess_missingdata_model, newdata = trainData)
anyNA(trainData) # All the missing values are successfully imputed.
#######################################################################
# Store X and Y for later use.
x = trainData[, 2:18]
y = trainData$Purchase
#######################################################################
# How to create One-Hot Encoding (dummy variables)
# One-Hot Encoding
# Creating dummy variables is converting a categorical variable to as many binary variables as here are categories.
dummies_model <- dummyVars(Purchase ~ ., data=trainData)
# Create the dummy variables using predict. The Y variable (Purchase) will not be present in trainData_mat.
trainData_mat <- predict(dummies_model, newdata = trainData)
# Convert to dataframe
trainData <- data.frame(trainData_mat)
# See the structure of the new dataset
str(trainData)
#######################################################################
# How to preprocess to transform the data?
# So what type of preprocessing are available in caret?
# range: Normalize values so it ranges between 0 and 1
# center: Subtract Mean
# scale: Divide by standard deviation
# BoxCox: Remove skewness leading to normality. Values must be > 0
# YeoJohnson: Like BoxCox, but works for negative values.
# expoTrans: Exponential transformation, works for negative values.
# pca: Replace with principal components
# ica: Replace with independent components
# spatialSign: Project the data to a unit circle
preProcess_range_model <- preProcess(trainData, method='range')
trainData <- predict(preProcess_range_model, newdata = trainData) #variabel targetnya hilang di sini
trainData$Purchase <- y #mengembalikan variabel target ke dalam sini
#######################################################################
# Store X and Y for later use.
x = trainData[, 2:18]
featurePlot(x= trainData[, 1:18],y= trainData$Purchase,plot = "box",strip=strip.custom(par.strip.text=list(cex=.7)),scales = list(x = list(relation="free"),y = list(relation="free")))
featurePlot(x= trainData[, 1:18],y= trainData$Purchase,plot = "density",strip=strip.custom(par.strip.text=list(cex=.7)),scales = list(x = list(relation="free"),y = list(relation="free")))
#######################################################################
# How to do feature selection using recursive feature elimination (rfe)
set.seed(100)
options(warn=-1)
subsets <- c(1:18) #berapa banyak variabel yang mau dicek?
ctrl <- rfeControl(functions = rfFuncs,method = "repeatedcv",repeats = 5,verbose = FALSE) #otomatis utk cari selection
lmProfile <- rfe(x=trainData[, 2:19], y=trainData$Purchase,sizes = subsets,rfeControl = ctrl) #otomatis utk cari selection
lmProfile
#######################################################################
# Training and Tuning the model
# How to train() the model and interpret the results?
# See available algorithms in caret
modelnames <- paste(names(getModelInfo()), collapse=',  ')
modelnames #model2 yang disupport ama CARET
#######################################################################
# Contoh pakai model earth
modelLookup('earth') #detail tentang model earth
# Set the seed for reproducibility
set.seed(100)
# Train the model using randomForest and predict on the training data itself.
model_mars = train(Purchase ~ ., data=trainData, method='earth')
fitted <- predict(model_mars)
model_mars
varimp_mars <- varImp(model_mars) #How to compute variable importance?
plot(varimp_mars, main="Variable Importance with MARS")
#######################################################################
# Prepare the test dataset and predict
# step 1: Missing Value imputation –> One-Hot Encoding –> Range Normalization
# yg harus dilakukan: preProcess_missingdata_model –> dummies_model –> preProcess_range_model
# Step 1: Impute missing values 
testData2 <- predict(preProcess_missingdata_model, testData)  
# Step 2: Create one-hot encodings (dummy variables)
testData3 <- predict(dummies_model, testData2)
# Step 3: Transform the features to range between 0 and 1
testData4 <- predict(preProcess_range_model, testData3)
# View
head(testData4[, 1:10])
#######################################################################
# Predict on testData
predicted <- predict(model_mars, testData4)
head(predicted)
confusionMatrix(reference = testData$Purchase,data = predicted)
roc_obj <- roc(as.numeric(testData$Purchase), as.numeric(predicted))
auc(roc_obj)

#######################################################################
# Define the training control --> utk fine tuning
fitControl <- trainControl(
    method = 'cv',                   # k-fold cross validation
    number = 5,                      # number of folds
    savePredictions = 'final',       # saves predictions for optimal tuning parameter
    classProbs = T,                  # should class probabilities be returned
    summaryFunction=twoClassSummary  # results summary function
) 

#######################################################################
# Model lain: ADABOOST
# Train the model using adaboost
model_adaboost = train(Purchase ~ ., data=trainData, method='adaboost', tuneLength=2, trControl = fitControl)
model_adaboost
#predicted <- predict(model_adaboost, testData4)
#head(predicted)
#confusionMatrix(reference = testData$Purchase,data = predicted)
#roc_obj <- roc(as.numeric(testData$Purchase), as.numeric(predicted))
#auc(roc_obj)

#######################################################################
# Model lain: RANDOM FOREST
# Train the model using rf
model_rf = train(Purchase ~ ., data=trainData, method='rf', tuneLength=5, trControl = fitControl)
model_rf

#######################################################################
# Model lain: xgBoost Dart
# Train the model using MARS
model_xgbDART = train(Purchase ~ ., data=trainData, method='xgbDART', tuneLength=5, trControl = fitControl, verbose=F)
model_xgbDART

#######################################################################
# Model lain: SVM
# Train the model using MARS
model_svmRadial = train(Purchase ~ ., data=trainData, method='svmRadial', tuneLength=15, trControl = fitControl)
model_svmRadial

#######################################################################
# COMPARING MODELS
models_compare <- resamples(list(ADABOOST=model_adaboost, RF=model_rf, XGBDART=model_xgbDART, MARS=model_mars, SVM=model_svmRadial))
# Summary of the models performances
summary(models_compare)
scales <- list(x=list(relation="free"), y=list(relation="free"))
bwplot(models_compare, scales=scales)




#######################################################################
# Ensembling the predictions --> PALING PENTING INI
library(caretEnsemble)
# Stacking Algorithms - Run multiple algos in one call.
trainControl <- trainControl(method="repeatedcv",number=10,repeats=3,savePredictions=TRUE,classProbs=TRUE)
algorithmList <- c('rf', 'adaboost', 'earth', 'xgbDART', 'svmRadial')
set.seed(100)
models <- caretList(Purchase ~ ., data=trainData, trControl=trainControl, methodList=algorithmList) 
results <- resamples(models)
summary(results)
scales <- list(x=list(relation="free"), y=list(relation="free"))
bwplot(results, scales=scales)

#######################################################################
# How to combine the predictions of multiple models to form a final prediction
# --> PALING PENTING INI

# Create the trainControl
set.seed(101)
stackControl <- trainControl(method="repeatedcv",number=10,repeats=3,savePredictions=TRUE,classProbs=TRUE)

# Ensemble the predictions of `models` to form a new combined prediction based on glm
stack.glm <- caretStack(models, method="glm", metric="Accuracy", trControl=stackControl)
print(stack.glm)
stack_predicteds <- predict(stack.glm, newdata=testData4)
head(stack_predicteds)
confusionMatrix(reference = testData$Purchase,data = stack_predicteds)
roc_obj <- roc(as.numeric(testData$Purchase), as.numeric(stack_predicteds))
auc(roc_obj)
