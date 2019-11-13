rm(list=ls())
library(NLP)
library(tm)
library(RColorBrewer)
library(e1071)
library(gmodels)
sms_raw <-read.csv("sms_wa.csv", stringsAsFactors = FALSE)

#Membuat train vs test secara otomatis
#Menggunakan library lattice
library(lattice)
library(caret)
set.seed(7267166)
#BESTMODEL WITH 0.7
trainIndex=createDataPartition(sms_raw$type, p=0.7)$Resample1
sms.train=sms_raw[trainIndex, ]
sms.test=sms_raw[-trainIndex, ]
print(table(sms_raw$type))
print(table(sms.train$type))
print(table(sms.test$type))

#mengubah jadi faktor
#ingat! karena naivebayes harus diubah jadi factor duyu
sms.train$type <-factor(sms.train$type)
sms.test$type <-factor(sms.test$type)

#Fungsi khusus
convert_counts <-function(x) {
  x <-ifelse(x > 0, "YES", "No")
}

#CORPUS TRAIN
sms_corpus.train <- VCorpus(VectorSource(sms.train$text))
sms_corpus_clean.train <-tm_map(sms_corpus.train, content_transformer(tolower))
sms_corpus_clean.train <- tm_map(sms_corpus_clean.train, removeNumbers)
sms_corpus_clean.train <-tm_map(sms_corpus_clean.train, removeWords, stopwords())
sms_corpus_clean.train <- tm_map(sms_corpus_clean.train, removePunctuation)
sms_corpus_clean.train <- tm_map(sms_corpus_clean.train, stemDocument)
sms_corpus_clean.train <- tm_map(sms_corpus_clean.train, stripWhitespace)

#CORPUS TEST
sms_corpus.test <- VCorpus(VectorSource(sms.test$text))
sms_corpus_clean.test <-tm_map(sms_corpus.test, content_transformer(tolower))
sms_corpus_clean.test <- tm_map(sms_corpus_clean.test, removeNumbers)
sms_corpus_clean.test <-tm_map(sms_corpus_clean.test, removeWords, stopwords())
sms_corpus_clean.test <- tm_map(sms_corpus_clean.test, removePunctuation)
sms_corpus_clean.test <- tm_map(sms_corpus_clean.test, stemDocument)
sms_corpus_clean.test <- tm_map(sms_corpus_clean.test, stripWhitespace)

sms_dtm.train <-DocumentTermMatrix(sms_corpus_clean.train)
sms_dtm.test <-DocumentTermMatrix(sms_corpus_clean.test)

sms_data_train <- sms_dtm.train
sms_data_test <- sms_dtm.test
sms_train_labels <- sms.train$type
sms_test_labels <- sms.test$type

prop.table(table(sms_train_labels))
prop.table(table(sms_test_labels))

#ini freq terms-nya bisa dibuat beda2
#kalau dibuat 1 malah jadi makin oke yah
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


#MELAKUKAN UJI DENGAN SMS BARU
#Simpansms baru di sms_uji.csv yah
sms_baru <-read.csv("sms_uji.csv", stringsAsFactors = FALSE)
sms_corpus <- VCorpus(VectorSource(sms_baru$text))
sms_corpus_clean <-tm_map(sms_corpus, content_transformer(tolower))
sms_corpus_clean <- tm_map(sms_corpus_clean, removeNumbers)
sms_corpus_clean <-tm_map(sms_corpus_clean, removeWords, stopwords())
sms_corpus_clean <- tm_map(sms_corpus_clean, removePunctuation)
sms_corpus_clean <- tm_map(sms_corpus_clean, stemDocument)
sms_corpus_clean <- tm_map(sms_corpus_clean, stripWhitespace)
sms_dtm <-DocumentTermMatrix(sms_corpus_clean)
sms_data_uji <- sms_dtm

#FREQTERMS-nya disesuaikan aja
#set awal di 5 seperti di atas, jika gak muncul, turunkan terus.
#minimal itu cuma 1

sms_freq_terms <- findFreqTerms(sms_data_uji, 2)
sms_data_freq_uji <- sms_data_uji[ , sms_freq_terms]
sms_uji <- apply(sms_data_freq_uji, MARGIN = 2, convert_counts)
sms_test_uji <-predict(sms_classifier_train2, sms_uji)
sms_test_uji
sms_baru$text
data.frame(sms_test_uji,sms_baru$text)