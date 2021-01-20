library(rvest)
library(polite)

rm(list=ls())

url = "https://www.tokopedia.com/bstn/evomass-10lbs?whid=0"

read_html(url) %>% 
  html_nodes(".items") %>% 
  html_text()

library(RSelenium)
rD <- rsDriver(browser="firefox", port=4545L, verbose=F)
remDr <- rD[["client"]]


system("docker run -d -p 4445:4444 selenium/standalone-firefox")
