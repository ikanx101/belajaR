rm(list=ls())
setwd('C:/Users/fadhli.mohammad/AppData/Local/Programs/Python/Python38-32/Scripts')

#system('instagram-scraper nutrifood -m 10')
system('instagram-scraper nutrifood -m 100 --media-types none --comments')

library(jsonlite)
library(tidyverse)
library(listviewer)

data = fromJSON('C:/Users/fadhli.mohammad/AppData/Local/Programs/Python/Python38-32/Scripts/nutrifood/nutrifood.json')

#kalau mw melihat list pake listviewer
data %>% pluck(1) %>% jsonedit()

data = data %>% pluck(1) %>% jsonlite::flatten() %>% as.tibble()

#bebersih
data = data %>% janitor::clean_names() %>% rowid_to_column('post')
glimpse(data)

tes = 
  data %>% select(tipe=typename,
                  post_id=post,
                  tags,
                  time = taken_at_timestamp,
                  comments = comments_data,
                  n_like = edge_media_preview_like_count,
                  link = thumbnail_src) %>%
  mutate(tags = map_chr(tags,toString),
         time = as.POSIXct(time,origin='1970-01-01')) %>%
  unnest_wider(comments) %>%
  unnest()

tes = tes %>% mutate(created_at = as.POSIXct(created_at,origin='1970-01-01'),
               text = gsub("[^[:alnum:] ]", "", text)) 

#bikin chart
setwd('D:/Project_R/Instagram Scraper')
library(ggplot2)
tes %>% group_by(tipe) %>% summarise(n=length(unique(post_id))) %>%
  mutate(tipe=case_when(tipe=='GraphSidecar'~ 'Multiple images',
                        tipe=='GraphImage' ~ 'Single image',
                        tipe=='GraphVideo' ~ 'Video')) %>%
  ggplot(aes(x=reorder(tipe,-n),y=n)) + geom_point(size=15) +
  geom_segment(aes(x=tipe,xend=tipe,y=0,yend=n),size=2) +
  geom_text(aes(label=n),color='white') +
  labs(title='Banyaknya jenis post yang dilakukan akun Instagram @nutrifood',
       subtitle='Scraped from Instagram at 21 Oct 2019 11:30 am',
       caption='Using Python via R\ni k A n x') +
  ggthemes::theme_economist() +
  theme(axis.text.x = element_text(size=12,face='bold'),
        axis.title = element_blank(),
        axis.text.y = element_blank(),
        plot.title = element_text(size=23,face='bold.italic'),
        plot.caption = element_text(size=9,face='italic'),
        plot.subtitle = element_text(size=15,face='italic'))
ggsave('Tipe Post.png',width = 12,height = 8)

tes %>% group_by(post_id,tipe) %>% summarise(n_like = mean(n_like)) %>%
  mutate(tipe=case_when(tipe=='GraphSidecar'~ 'Multiple images',
                              tipe=='GraphImage' ~ 'Single image',
                              tipe=='GraphVideo' ~ 'Video')) %>%
  filter(tipe!='Video') %>% ggplot(aes(tipe,n_like)) +
  geom_boxplot(color='steelblue') +
  geom_dotplot(binaxis='y', 
               stackdir='center', 
               dotsize = .5, 
               fill="darkred",alpha=.6) + 
  labs(x='Jenis post',
       y='Likes',
       title='Sebaran likes netizen per tipe post Instagram @nutrifood',
       subtitle='Scraped from Instagram at 21 Oct 2019 11:30 am',
       caption='Using Python via R\ni k A n x') + 
  ggthemes::theme_wsj() +
  theme(axis.title = element_blank(),
        plot.title=element_text(size=23,face='bold.italic'),
        plot.subtitle=element_text(size=15,face='italic'),
        plot.caption = element_text(size=9,face='italic'),
        axis.text.y = element_blank())
ggsave('Tipe Post vs likes.png',width = 12,height = 8)

tes %>% group_by(post_id) %>% summarise(n_like = mean(n_like),
                                        komen = n()) %>%
  arrange(desc(komen)) %>% head(20) %>%
  ggplot(aes(x=n_like,y=komen,label=post_id)) + geom_point() + 
  ggrepel::geom_text_repel() +
  ggthemes::theme_clean() +
  geom_vline(xintercept = 432,color='blue',alpha=0.6) +
  geom_hline(yintercept = 11,color='blue',alpha=0.6) +
  labs(title='Likes vs Comments dari 20 post terakhir Instagram @nutrifood',
       subtitle='Scraped from Instagram at 21 Oct 2019 11:30 am',
       caption='Using Python via R\ni k A n x',
       x='Berapa banyak netizen yang likes?',
       y='Berapa banyak netizen yang komen?') +
  theme(plot.title=element_text(size=23,face='bold.italic'),
        plot.subtitle=element_text(size=15,face='italic'),
        plot.caption = element_text(size=9,face='bold.italic'),
        axis.title = element_text(size=14,face='bold'))
ggsave('Likes vs Komen.png',width = 12,height = 8)
