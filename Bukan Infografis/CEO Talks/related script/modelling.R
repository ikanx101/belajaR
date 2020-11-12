rm(list=ls())
library(dplyr)

load("untuk model.rda")

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
id_train_ceo = sample(72,60,replace = FALSE)
id_train_bukan = sample(104,60,replace = FALSE)

# dipisah dua
data_ceo = 
  data %>% 
  filter(label == "CEO")
data_bukan = 
  data %>% 
  filter(label != "CEO")

train_data = rbind(data_ceo[id_train_ceo,],
                   data_bukan[id_train_bukan,])
train_data$label = factor(train_data$label)
table(train_data$label)

test_data = rbind(data_ceo[-id_train_ceo,],
                  data_bukan[-id_train_bukan,])
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

save(sms_classifier_train2,convert_counts,file = "model.rda")

# ================
rm(list=ls())
load("model.rda")
text = c("leader ceo covid innovation",
         "person year call risk")
coba = VCorpus(VectorSource(text))

sms_corpus_clean.coba = tm_map(coba, content_transformer(tolower))
sms_corpus_clean.coba = tm_map(sms_corpus_clean.coba, removeNumbers)
sms_corpus_clean.coba = tm_map(sms_corpus_clean.coba, removePunctuation)
sms_corpus_clean.coba = tm_map(sms_corpus_clean.coba, stripWhitespace)

sms_dtm.coba = DocumentTermMatrix(sms_corpus_clean.coba)

sms_freq_terms.coba <- findFreqTerms(sms_dtm.coba, 1)
sms_data_freq_coba <- sms_dtm.coba[ , sms_freq_terms.coba]

sms_coba <- apply(sms_data_freq_coba, MARGIN = 2, convert_counts)

predict(sms_classifier_train2, sms_coba,type = "raw")

