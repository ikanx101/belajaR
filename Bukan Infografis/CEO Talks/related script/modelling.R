rm(list=ls())
library(dplyr)

data_1 = read.csv("https://raw.githubusercontent.com/ikanx101/belajaR/master/Bukan%20Infografis/CEO%20Talks/wordpress%20(1).csv") %>%
        rename(artikel = kalimat)
data_2 = read.csv("https://raw.githubusercontent.com/ikanx101/belajaR/master/Bukan%20Infografis/CEO%20Talks/artikel%20leadership.csv")

str(data_1)
str(data_2)

rand = sample(450,50,replace=F)
data_1 = data_1[rand,]

data = rbind(data_1,data_2)
str(data)

#install.packages("NLP")
#install.packages("tm")
#install.packages("e1071")
#install.packages("gmodels")

library(NLP)
library(tm)
library(e1071)
library(gmodels)

set.seed(10104074)
id_train = sample(95,76,replace = FALSE)
train_data = data[id_train,]
train_data$label = factor(train_data$label)
table(train_data$label)
test_data = data[-id_train,]
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

save(sms_classifier_train2,file = "model.rda")
