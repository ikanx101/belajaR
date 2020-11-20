rm(list=ls())
library(dplyr)
setwd("~/belajaR/Bukan Infografis/CEO Talks/version 2")

load("version 2.rda")
data = dbase_link_new

# kita bagi train dan test di sini
table(data$label)

#install.packages("NLP")
#install.packages("tm")
#install.packages("e1071")
#install.packages("gmodels")

library(NLP)
library(tm)
library(e1071)
library(gmodels)

set.seed(10104074)
id_train_agility = sample(1843,1700,replace = FALSE)
id_train_inclusive = sample(1682,1500,replace = FALSE)
id_train_purposeful = sample(1464,1300,replace = FALSE)
id_train_digtrans = sample(799,680,replace = FALSE)

# dipisah empat
data_agility = 
  data %>% 
  filter(label == "agility")
data_inclusive = 
  data %>% 
  filter(label == "inclusive")
data_purposeful = 
  data %>% 
  filter(label == "purposeful")
data_digtrans = 
  data %>% 
  filter(label == "digital transformation")

train_data = rbind(data_agility[id_train_agility,],
                   data_inclusive[id_train_inclusive,],
                   data_purposeful[id_train_purposeful,],
                   data_digtrans[id_train_digtrans,])
train_data$label = factor(train_data$label)
table(train_data$label)

test_data = rbind(data_agility[-id_train_agility,],
                  data_inclusive[-id_train_inclusive,],
                  data_purposeful[-id_train_purposeful,],
                  data_digtrans[-id_train_digtrans,])
train_data$label = factor(train_data$label)
test_data$label = factor(test_data$label)
table(test_data$label)

# CORPUS TRAIN
sms_corpus.train = VCorpus(VectorSource(train_data$artikel))
sms_corpus_clean.train = tm_map(sms_corpus.train, content_transformer(tolower))
sms_corpus_clean.train = tm_map(sms_corpus_clean.train, removeNumbers)
sms_corpus_clean.train = tm_map(sms_corpus_clean.train, removePunctuation)
sms_corpus_clean.train = tm_map(sms_corpus_clean.train, stripWhitespace)

# CORPUS TEST
sms_corpus.test = VCorpus(VectorSource(test_data$artikel))
sms_corpus_clean.test = tm_map(sms_corpus.test, content_transformer(tolower))
sms_corpus_clean.test = tm_map(sms_corpus_clean.test, removeNumbers)
sms_corpus_clean.test = tm_map(sms_corpus_clean.test, removePunctuation)
sms_corpus_clean.test = tm_map(sms_corpus_clean.test, stripWhitespace)

sms_dtm.train = DocumentTermMatrix(sms_corpus_clean.train)
sms_dtm.test = DocumentTermMatrix(sms_corpus_clean.test)

sms_data_train = sms_dtm.train
sms_data_test = sms_dtm.test
sms_train_labels = train_data$label
sms_test_labels = test_data$label

convert_counts <-function(x) {
    x <-ifelse(x > 0, "YES", "No")
}

sms_freq_terms.train <- findFreqTerms(sms_data_train, 1)
sms_freq_terms.test <- findFreqTerms(sms_data_test, 1)

sms_data_freq_train <- sms_data_train[ , sms_freq_terms.train]
sms_data_freq_test <- sms_data_test[ , sms_freq_terms.test]

sms_train <- apply(sms_data_freq_train, MARGIN = 2, convert_counts)
sms_test <- apply(sms_data_freq_test, MARGIN = 2, convert_counts)

sms_classifier_train2 <- naiveBayes(sms_train, sms_train_labels, laplace = 1)
sms_test_pred2 <-predict(sms_classifier_train2, sms_test)
predict=sms_test_pred2
actual=sms_test_labels

trainTable.bayes=table(actual, predict)
trainTable.bayes
mean(actual==predict)

new = predict(sms_classifier_train2, sms_test,type = "raw")
head(new)

save(sms_classifier_train2,convert_counts,file = "model version 2.rda")