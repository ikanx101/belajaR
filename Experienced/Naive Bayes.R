rm(list=ls())

#Computes the conditional a-posterior probabilities of a categorical class variable given independent predictor variables using the Bayes rule.
#ceritanya ini menggunakan set theory (P x|y) utk menentukan peluang terjadi suatu kejadian
#kali ini contohnya memprediksi gender based on panjang rambut

#contoh data yang dipakai
jk=c("pria","pria","pria","pria","pria","pria","pria","pria","pria","pria","pria","pria","pria","pria","wanita","wanita","wanita","wanita","wanita","wanita","wanita","wanita","wanita","wanita","wanita","wanita")
rambut=c("panjang","panjang","panjang","pendek","pendek","pendek","pendek","pendek","pendek","pendek","pendek","pendek","pendek","pendek","panjang","panjang","panjang","panjang","panjang","panjang","panjang","panjang","panjang","panjang","panjang","pendek")

#paling bener kalau datanya dibuka dari csv, lebih bener dibandingkan import dari excel
#gabungan=read.csv(file.choose(),header=T)

#datanya digabung pake fungsi data.frame ya
gabungan=data.frame(jk,rambut)
gabungan

#kita buat partitioningnya dulu yah
library(caret)
set.seed(7267166)
trainIndex=createDataPartition(gabungan$jk, p=0.6)$Resample1
train=gabungan[trainIndex, ]
test=gabungan[-trainIndex, ]
print(table(gabungan$jk))
print(table(train$jk))
print(table(test$jk))

library(e1071)

#membuat model
#penting bagi bayes, independen harus berupa faktor. bukan numerik!
#mengubah numerik ke faktor --> model=naiveBayes(as.factor(jk)~.,data=train)
model=naiveBayes(jk~.,data=train)
model

#fungsi jk~. maksudnya adalah menggunakan variabel selain dependen utk memprediksi. Ini gunanya jika set datanya ada banyak variabel.
#Jika hanya ingin selected independent variabel, maka tulisnya jk~rambut

#fitness model - train data
trainPred=predict(model, newdata=train, type = "class")
trainTable=table(train$jk, trainPred)
trainTable

#fitness model - test data
testPred=predict(model, newdata = test, type = "class")
testTable=table(test$jk, testPred)
testTable

#Misalkan kita ingin memprediksi orang berambut pendek itu apa gendernya, pakai fungsi ini:
predict(model,"pendek",type="raw")
predict(model,"pendek",type="class")

#predict(model,"______diisi datanya______",type="raw")