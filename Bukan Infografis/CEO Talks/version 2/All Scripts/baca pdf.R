setwd("~/Documents/belajaR/Bukan Infografis/CEO Talks/version 2/Data Bank/pdf")
rm(list=ls())

pdf = list.files()

library(pdftools)
library(dplyr)
library(tidytext)
library(tidyr)

hasil = c()
for(i in 1:7){
  baca = pdf_text(pdf[i])
  hasil = c(hasil,baca)
}

hasil = paste(hasil,collapse = " ")

hasil = gsub("\n"," ",hasil)
hasil = trimws(hasil)
hasil = gsub("\t"," ",hasil)
hasil = gsub("\r"," ",hasil)
hasil = gsub("  "," ",hasil)
hasil
