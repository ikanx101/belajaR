rm(list=ls())

load("untuk model.rda")

sink("kata.txt")
print(paste(sort(unique(words_400)),collapse = " "))
sink()

data = data.frame(words = words_400, n = 1)

library(htmlwidgets)
wc = 
  wordcloud2::wordcloud2(data,
                         color = "random-dark", 
                         backgroundColor = "white",
                         fontFamily = "Miso",
                         size=2)
saveWidget(wc,"1.html",selfcontained = F)
webshot::webshot("1.html","1.png",vwidth = 900, vheight = 700, delay = 20)