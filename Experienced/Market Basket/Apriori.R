rm(list=ls())

#loading library yang dibutuhkan di R
library(tidyverse)
library(readxl)
library(knitr)
library(ggplot2)
library(lubridate)
library(arules)
library(arulesViz)
library(plyr)

#source directory-nya tinggal diganti saja
setwd("D:/Project_R/Market Basket Analysis/Nutrimart")
retail <- read.csv("basket_new.csv")
glimpse(retail)
str(retail)

retail$parent.item=as.factor(retail$parent.item)
retail$id.transaksi=as.factor(retail$id.transaksi)

detach("package:plyr", unload=TRUE)
top.10.product=retail %>% 
    group_by(parent.item) %>% 
    summarize(count = n()) %>% 
    arrange(desc(count))
top.10.product

#Convert bentuk data tabular ke dalam bentuk transaksional
#data transaksi baris perbaris
#data disort berdasarkan id.transaksi
retail_sorted <- retail[order(retail$id.transaksi),]
library(plyr)
itemList <- ddply(retail,c("id.transaksi"), function(df1)paste(df1$parent.item, collapse =","))
itemList$id.transaksi <- NULL
colnames(itemList) <- c("items")

#Exporting transaction data
write.csv(itemList,"market_basket.csv", quote = FALSE, row.names = TRUE)
rm(list=ls())
tr <- read.transactions('market_basket.csv', format = 'basket', sep=',')
tr
summary(tr)

#Algoritma membangun association rules
rules <- apriori(tr, parameter = list(supp=0.001, conf=0.8))
rules <- sort(rules, by=c('confidence','count'), decreasing = TRUE)
summary(rules)

#TOP 10 rules
#yang sorted based on confidence dan count
inspect(rules[1:10])
topRules <- rules[1:10]
plot(topRules, method="graph")
xx=plot(topRules,method="graph",engine='interactive',shading=NA)

write(topRules,file = "association_rules.csv",sep = ",",quote = TRUE,row.names = FALSE)
library(htmlwidgets)
saveWidget(xx,file='association_rules.html')
