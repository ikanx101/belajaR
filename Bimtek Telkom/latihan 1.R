rm(list=ls())
setwd("/cloud/project/Bimtek Telkom")

##########
#ambil data
url = 'https://raw.githubusercontent.com/rc-dbe/bigdatacertification/master/dataset/churn_trasnsformed_new.csv'
data = read.csv(url)
colnames(data) = tolower(colnames(data))

##########
#mari kita mulai fun parts-nya
#kita mau pisah yah
#train dan test dataset
library(caret)
library(pROC)
# Create the training and test datasets
set.seed(100)

prop.table(table(data$churn))

# Step 1: Get row numbers for the training data
trainRowNumbers <- createDataPartition(data$churn, p=0.7, list=FALSE)

# Step 2: Create the training  dataset
trainData <- data[trainRowNumbers,]
prop.table(table(trainData$churn))

# Step 3: Create the test dataset
testData <- data[-trainRowNumbers,]
prop.table(table(testData$churn))

# Define the training control --> utk fine tuning
fitControl <- trainControl(
  method = 'cv',                   # k-fold cross validation
  number = 5,                      # number of folds
  savePredictions = 'final',       # saves predictions for optimal tuning parameter
  classProbs = T,                  # should class probabilities be returned
  summaryFunction=twoClassSummary  # results summary function
) 

#######################################################################
# Model lain: RANDOM FOREST
# Train the model using rf
model_rf = train(churn ~ ., data=trainData, method='rf', tuneLength=5, trControl = fitControl)
model_rf