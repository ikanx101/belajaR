rm(list=ls())
library(dplyr)
library(janitor)

artikel = readLines("https://raw.githubusercontent.com/ikanx101/belajaR/master/Bukan%20Infografis/CEO%20Talks/another%20article.txt")

str(artikel)
gabung = ""
for(i in 1:93){
  gabung = paste(gabung,artikel[i])
}

gabung = gsub("\\n","",gabung)
gabung = gsub("\\t","",gabung)
gabung = gsub("\\r","",gabung)
gabung = trimws(gabung)

gabung = strsplit(gabung,split = "\\.")
gabung = unlist(gabung)
gabung = make_clean_names(gabung)
gabung = gsub("\\_"," ",gabung)

str(gabung)
data_lain = data.frame(
  id = c(1:45),
  artikel = gabung,
  label = "Bukan CEO"
)
write.csv(data_lain,"artikel leadership.csv")
