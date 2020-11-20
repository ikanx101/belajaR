rm(list=ls())
library(dplyr)
library(rvest)
library(tidytext)
library(tidyr)

# ambilin links
setwd("~/belajaR/Bukan Infografis/CEO Talks/version 2/Data Bank")
label = list.files()
label = label[grep("txt",label)]
dbase_link = data.frame(link = c(),label = c())
for(i in 1:length(label)){
  link = readLines(label[i])
  temp = data.frame(link = link,label = label[i])
  dbase_link = rbind(dbase_link,temp)
}

# bebersih link
setwd("~/belajaR/Bukan Infografis/CEO Talks/version 2")
dbase_link =
  dbase_link %>% 
  distinct() %>% 
  filter(grepl("2020|2019|2018|2017|2016|2015|2014|2013|2012|2011|2010",link)) %>% 
  filter(!grepl("pdf|webinar|podcast|sponsored",link,ignore.case = T))

# scrape func
scrape_hbr = function(url){
  teks = 
    url %>% 
    read_html() %>% 
    html_nodes("p") %>% 
    html_text(trim = T)
  teks = paste(teks,collapse = " ")
  teks = trimws(teks)
  teks = tolower(teks)
  return(teks)
}
dbase_link$artikel = sapply(dbase_link$link,scrape_hbr)

# yang ini utk baca pdf agility dari nochay
setwd("~/belajaR/Bukan Infografis/CEO Talks/version 2/Data Bank/pdf")
pdf = list.files()
library(pdftools)
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
dbase_link[73,] = c("pdf","agility",hasil)

# sekarang kita bebersih
dbase_new = 
  dbase_link %>% 
  unnest_tokens(out,artikel,token = "regex",pattern = "\\.") %>%
  filter(stringr::str_length(out) > 25) %>% 
  mutate(out = janitor::make_clean_names(out),
         out = gsub("\\_"," ",out),
         label = gsub(".txt","",label),
         kalimat_ke = c(1:length(out)))

# english stopwords
stop_en = readLines("https://raw.githubusercontent.com/stopwords-iso/stopwords-en/master/stopwords-en.txt")
stop_en = c(stop_en,"they","agile","agility","purposeful","purpose","digital","transformation","inclusive",
            "dancer")

# removing stopwords
dbase_new = 
  dbase_new %>% 
  unnest_tokens(words,out,token = "words") %>% 
  filter(!words %in% stop_en) %>% 
  filter(stringr::str_length(words) > 3) %>% 
  mutate(penanda = as.numeric(words)) %>% 
  filter(is.na(penanda)) %>% 
  select(-penanda)

# =======================================
# wordcloud
# agility
agility = 
  dbase_new %>% 
  filter(label == "agility") %>% 
  group_by(words) %>% 
  count(sort = T) %>% 
  ungroup() %>% 
  filter(!words %in% c("jeffrey","cynthia","mckinsey","ebrahim","simon",
                       "21st","sherina","https")) %>% 
  head(100)

agility %>% wordcloud2::wordcloud2(minRotation = -pi/6, maxRotation = -pi/6, rotateRatio = 1,
                                   color='random-light', backgroundColor="black")

# inclusive
inclusive = 
  dbase_new %>% 
  filter(label == "inclusive") %>% 
  group_by(words) %>% 
  count(sort = T) %>% 
  ungroup() %>% 
  filter(!words %in% c("inclusion","lgbt","black")) %>% 
  head(100) 

inclusive %>% wordcloud2::wordcloud2(minRotation = -pi/6, maxRotation = -pi/6, rotateRatio = 1,
                                     color='random-light', backgroundColor="black")

# purposeful
purposeful = 
  dbase_new %>% 
  filter(label == "purposeful") %>% 
  group_by(words) %>% 
  count(sort = T) %>% 
  ungroup() %>% 
  head(100)

purposeful %>% wordcloud2::wordcloud2(minRotation = -pi/6, maxRotation = -pi/6, rotateRatio = 1,
                                      color='random-light', backgroundColor="black")


# digital transformation
digtrans = 
  dbase_new %>% 
  filter(label == "digital transformation") %>% 
  group_by(words) %>% 
  count(sort = T) %>% 
  ungroup() %>% 
  filter(!words %in% c("india")) %>% 
  head(100)

digtrans %>% wordcloud2::wordcloud2(minRotation = -pi/6, maxRotation = -pi/6, rotateRatio = 1,
                                    color='random-light', backgroundColor="black")

# sekarang gabung semua katanya
kata = rbind(agility,inclusive)
kata = rbind(kata,purposeful)
kata = rbind(kata,digtrans)
kata = sort(unique(kata$words))

# kita save semua ya
setwd("~/belajaR/Bukan Infografis/CEO Talks/version 2")
kata_print = paste(kata,collapse = " ")
sink("all words.txt");print(kata_print);sink()

dbase_link_new = 
  dbase_new %>% 
  filter(words %in% kata) %>% 
  group_by(kalimat_ke,link,label) %>% 
  summarise(artikel = paste(words,collapse = " ")) %>% 
  ungroup()

save(dbase_link,dbase_link_new,file = "version 2.rda")