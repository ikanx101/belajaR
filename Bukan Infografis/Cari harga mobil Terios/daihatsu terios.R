rm(list=ls())

setwd("/cloud/project/Bukan Infografis/Cari harga mobil Terios")

#pannggil libraries
library(rvest)
library(dplyr)
library(tidyr)
library(tidytext)
library(ggplot2)
library(ggthemes)

#link dari carmudi utk daihatsu Terios
url = paste('https://www.carmudi.co.id/cars/daihatsu/terios/?page=',
            c(1:19),
            sep='')

#Bikin fungsi scrap
scrap = function(url){
  data = 
    read_html(url) %>% {
      tibble(
        nama = html_nodes(.,'.title-blue') %>% html_text(),
        harga = html_nodes(.,'.price a') %>% html_text(),
        lokasi = html_nodes(.,'.catalog-listing-item-location span') %>%
          html_text()
      )
    }
  return(data)
}

#kita mulai scrap datanya
i = 1
terios.data = scrap(url[i])

for(i in 2:length(url)){
  temp = scrap(url[i])
  terios.data = rbind(terios.data,temp)
}

#write as csv
write.csv(terios.data,'raw data carmudi terios.csv')

#kita bebersih yah
terios.data = 
  terios.data %>% mutate(nama = gsub('\\\n','',nama),
                       harga = gsub('juta','',harga,ignore.case = T),
                       harga = gsub('\\ ','',harga),
                       harga = as.numeric(harga),
                       lokasi = gsub('\\\n','',lokasi),
                       id = c(1:length(nama))) 

new = 
  terios.data %>% select(id,nama) %>%
  unnest_tokens('words',nama) %>% mutate(words = as.numeric(words)) %>%
  filter(!is.na(words),words>2000)

terios.data = merge(terios.data,new)
colnames(terios.data)[5] = 'tahun'

terios.data %>% group_by(tahun) %>% summarise(rata = mean(harga),stdev = sd(harga),n = n()) %>%
  ggplot(aes(x = as.factor(tahun), y = rata)) + geom_col(color='steelblue',fill='white',alpha=.4) +
  geom_errorbar(aes(ymin=rata-stdev, ymax=rata+stdev), width=.2,color='darkgreen') +
  labs(title = 'Harga Daihatsu Terios Bekas 2007 - 2019',
       subtitle = 'source: situs Carmudi Indonesia',
       caption = 'Scraped 26-11-19 16:30\nVisualised using R\ni k A n x',
       y = 'Harga(dalam juta rupiah)') +
  theme_pubr() +
  theme(axis.title.x = element_blank(),
        plot.title = element_text(size=25,face='bold.italic'))
ggsave('Terios Carmudi.png',width = 14, height = 10, dpi=450)
