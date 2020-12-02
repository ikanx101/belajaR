# ================================
# ALGORITMA SCRAPE RATE DAN REVIEWS
# Home Tester Club Indonesia
# by: ikanx101.com
# ================================

# dimulai dari hati yang bersih
rm(list=ls())

# load all libraries
library(dplyr)
library(rvest)
library(tidyr)

# baca semua links yang sudah diambil
link = readLines("links.txt")

# bikin function scrape
scrape_func = function(url){
  data = read_html(url) %>% {tibble(
      merek = html_nodes(.,"#htc-breadcrumb .active") %>% html_text(),
      rate = html_nodes(.,".pp-ratereview-counter li") %>% html_text() %>% paste(collapse = " "),
      deskripsi = (html_nodes(.,".text-left") %>% html_text())[[1]]
  )}
  return(data)
}


# scraping process
n = length(link)
data = data.frame(merek = c(),rate = c(),deskripsi = c())

for(i in 1:n){
  temp = scrape_func(link[i])
  data = rbind(data,temp)
  print(i)
}

raw_data = data

clean_data = 
  data %>% 
  separate(rate,
           into = c("rate_no","review_no"),
           sep = " dari ") %>% 
  mutate(rate_no = gsub("\\,",".",rate_no),
         rate_no = as.numeric(rate_no),
         review_no = gsub("\\.","",review_no),
         review_no = gsub("[A-z]","",review_no),
         review_no = gsub("\\&","",review_no),
         review_no = trimws(review_no),
         review_no = as.numeric(review_no)
         )

save(raw_data,clean_data,file = "data dapur makanan.rda")