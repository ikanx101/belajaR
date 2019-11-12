rm(list=ls())

#loading library yang dibutuhkan di R
library(tidyverse)
library(readxl)
library(knitr)
library(ggplot2)
library(lubridate)
library(arules)
library(arulesViz)


# Import dataset
data = read_excel('dataset/Online Retail.xlsx')
