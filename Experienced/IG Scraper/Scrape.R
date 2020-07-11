# IG Scraper
# cd /home/ikanx101githubio/.local/bin
rm(list=ls())

user = ''

setwd('~/Documents/belajaR/Experienced/IG Scraper')
system('instagram-scraper urun.id -m 5 --comments')

library(jsonlite)
library(tidyverse)
library(listviewer)

data = fromJSON('~/Documents/belajaR/Experienced/IG Scraper/urun.id/urun.id.json')
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
  unnest(cols = c(created_at,text))

tes = tes %>% mutate(created_at = as.POSIXct(created_at,origin='1970-01-01'),
                     text = gsub("[^[:alnum:] ]", "", text)) 
