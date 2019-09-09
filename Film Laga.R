rm(list=ls())
library(tidyverse)
library(rvest)

#ambil link film pergenre
movie_genre_url <- 
  read_html("http://filmindonesia.or.id/movie") %>% 
  html_nodes("#genre-list a") %>% 
  {
    tibble(
      genre = html_text(.),
      genre_url = html_attr(., "href")
    )
  }

#cek film laga
laga = movie_genre_url %>% filter(genre=='Laga')
laga = laga$genre_url

#membaca judul
title = read_html(laga) %>% html_nodes('h4') %>% html_text()
title = strsplit(title,'-')
title = paste('Sepanjang sejarah perfilm-an Indonesia, ada',unlist(title)[2],' film laga yang diproduksi.',sep='')

#memulai iterasi pertama
film_raw = read_html(laga) %>% html_nodes('h3 a') %>% html_text()
n = length(film_raw)
ganjil = seq(1,(n-1),by=2)
genap = seq(2,n,by=2)

judul_film = film_raw[ganjil]
tahun_film = film_raw[genap]
data = data.frame(judul_film,tahun_film)

film_raw = read_html(laga) %>% html_nodes('h3 a') %>% html_attr('href')
link_film = film_raw[ganjil]
data$link = link_film

#kita akan mulai membaca keseluruhan film
url_all = paste(laga,c(2:44)*10,sep='/')

for(i in 1:length(url_all)){
  film_raw = read_html(url_all[i]) %>% html_nodes('h3 a') %>% html_text()
  n = length(film_raw)
  ganjil = seq(1,(n-1),by=2)
  genap = seq(2,n,by=2)
  
  judul_film = film_raw[ganjil]
  tahun_film = film_raw[genap]
  dummy = data.frame(judul_film,tahun_film)
  
  film_raw = read_html(url_all[i]) %>% html_nodes('h3 a') %>% html_attr('href')
  link_film = film_raw[ganjil]
  dummy$link = link_film
  data = rbind(data,dummy)
}

#hitung banyak film per tahun
banyak_film_per_tahun = data %>% group_by(tahun_film) %>% summarise(banyak.film=n()) %>% 
  mutate(tahun_film=as.character(tahun_film)) %>% arrange(tahun_film)

#gruping tahun per era
banyak_film_per_tahun = banyak_film_per_tahun %>% mutate(tahun_film=as.numeric(tahun_film)) %>% 
  mutate(tahun = case_when((tahun_film<1970) ~ 'Sebelum era 70an',
                           (tahun_film>=1970 & tahun_film<1980) ~ 'Era 70an',
                           (tahun_film>=1980 & tahun_film<1990) ~ 'Era 80an',
                           (tahun_film>=1990 & tahun_film<2000) ~ 'Era 90an',
                           (tahun_film>=2000 & tahun_film<2010) ~ 'Era 2000an',
                           (tahun_film>=2010 ) ~ 'Era 2010an')) %>%
  group_by(tahun) %>% summarise(banyak.film = sum(banyak.film))

#bikin jadi factor
library(ggthemes)
png('Film Laga.png',width = 900,height = 500,units = 'px')
banyak_film_per_tahun %>% mutate(tahun=factor(tahun,levels = c('Sebelum era 70an',
                                                              'Era 70an',
                                                              'Era 80an',
                                                              'Era 90an',
                                                              'Era 2000an',
                                                              'Era 2010an'))) %>%
  ggplot(aes(x=tahun,y=banyak.film,label=banyak.film)) + geom_line(stat = 'identity',group=1,size=1.5,colour='dark red') + 
  theme_tufte() + labs(title = 'Banyaknya film laga Indonesia yang diproduksi dan tayang di bioskop',x='Era perfilman Indonesia',y='Banyaknya film') +
  theme(axis.text.y = element_blank(),plot.title = element_text(size=20)) + geom_text(size=4,vjust=2) +
  labs(subtitle = 'sumber: http://filmindonesia.or.id',caption = 'Scraped using R') +
  theme(axis.title.x = element_text(size = 14),axis.title.y = element_text(size = 14),axis.text.x = element_text(size = 12))
dev.off()

#sebagian kode ini terinspirasi dari KamisData R
