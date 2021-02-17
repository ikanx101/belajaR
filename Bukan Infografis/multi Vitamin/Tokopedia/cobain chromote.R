rm(list=ls())

library(dplyr)
library(chromote)
library(tictoc)

# links
url = readLines("link final 3 done 3 Feb.txt")

# setting
b <- ChromoteSession$new()
b$Network$setUserAgentOverride(userAgent = "My fake browser")
b$view()
cookies <- b$Network$getCookies()
b$Network$setCookies(cookies = cookies$cookies)

chrome_do_your_magic = function(link){
  # navigate
  b$Page$navigate(link)
  Sys.sleep(10)
  # extract nama
  x <- b$Runtime$evaluate('document.querySelector(".css-v7vvdw").innerText')
  nama = x$result$value
  nama = ifelse(is.null(nama),NA,nama)
  # extract terjual
  x <- b$Runtime$evaluate('document.querySelector(".items div:nth-child(1)").innerText')
  terjual = x$result$value
  terjual = ifelse(is.null(terjual),NA,terjual)
  # extract harga
  x <- b$Runtime$evaluate('document.querySelector(".price").innerText')
  harga = x$result$value
  harga = ifelse(is.null(harga),NA,harga)
  # extract toko
  x <- b$Runtime$evaluate('document.querySelector("#pdp_comp-shop_credibility h2").innerText')
  toko = x$result$value
  toko = ifelse(is.null(toko),NA,toko)
  asal = "tidak"
  data = data.frame(nama,terjual,harga,toko,asal)
  return(data)
}

i = 1
data = chrome_do_your_magic(url[i])

tic("start")

for(i in 2:length(url)){
  temp = chrome_do_your_magic(url[i])
  data = rbind(data,temp)
  print(i)
}

toc()

data$waktu.scrape = Sys.Date()	
data = distinct(data)

load("hasil scrape.rda")

raw = rbind(raw,data)
save(raw,file = 'hasil scrape.rda')