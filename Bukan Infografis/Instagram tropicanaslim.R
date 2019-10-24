setwd('D:/Project_R/Instagram Scraper')
data = tes

#ambil post tanpa komen dari akun @tropicanaslim
tak.ada.komen = 
  data %>% filter(is.na(created_at)) %>% select(tipe,post_id,n_like,link)

library(webshot)
for(i in 1:length(tak.ada.komen$link)){
  judul = paste('post ke',tak.ada.komen$post_id[i],'png',sep='.')
  tak.ada.komen$img[i] = judul
  webshot(tak.ada.komen$link[i],judul)
}

#dikasih notes, masing2 gambar itu apa
tak.ada.komen %>% mutate(post_id=factor(post_id,levels = post_id)) %>% 
  ggplot(aes(x=post_id,y=n_like)) + 
  geom_image(aes(image = img), size = 0.1,by='height') +
  geom_col(fill = 'yellow',alpha=.5) +
  theme_pubclean() +
  labs(y = 'Berapa banyak likes?',
       title = 'Posting IG yang Tidak Pernah Mendapatkan Komen',
       subtitle = 'sumber: 80 post terakhir dari @tropicanaslim',
       caption = 'Scraped and Visualized\n24Oct19 10:00AM\nusing R\ni k A n x') +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_text(size=5),
        axis.title.y = element_text(size=10),
        plot.caption = element_text(size=8,face='italic'))
ggsave('tes.png',width=7,height=6,dpi=450)

#ambil post paling banyak komen dari akun @tropicanaslim
komen = 
  data %>% filter(!is.na(created_at)) %>% group_by(post_id)

brp.komen = 
  komen %>% group_by(post_id) %>% summarise(n_komen=n(),n_like = mean(n_like))

#untuk ambil gambar
links = komen %>% group_by(post_id) %>% select(link) %>% distinct()
for(i in 1:length(links$link)){
  judul = paste('post ke',links$post_id[i],'png',sep='.')
  links$img[i] = judul
  webshot(as.character(links$link[i]),judul)
}

brp.komen = merge(brp.komen,links)

brp.komen %>% ggplot(aes(x=n_like,y=n_komen)) + 
  geom_image(aes(image=img),size=.05,by='height') +
  theme_pubclean() +
  labs(y = 'Berapa banyak komen?',
       x = 'Berapa banyak likes?',
       title = 'Posting IG yang Pernah Mendapatkan Komen dan Likes',
       subtitle = 'sumber: 80 post terakhir dari @tropicanaslim',
       caption = 'Scraped and Visualized\n24Oct19 10:00AM\nusing R\ni k A n x') +
  theme(axis.title = element_text(size=10,face='bold'),
        axis.text = element_text(size=5),
        axis.title.y = element_text(size=10),
        plot.caption = element_text(size=8,face='italic'))
ggsave('post dengan komen.png',width=10,height=10,dpi=450)

#kita cari siapa aja yang komen
komen %>% group_by(username) %>% summarise(n=n()) %>% filter(n>2) %>%
  arrange(n) %>%
  mutate(username=factor(username,levels=username)) %>%
  ggplot(aes(x=username,y=n)) +
  theme_pubclean() +
  geom_segment(aes(x=username, xend=username, y=0, yend=n),
               color = alpha("yellow", 0.5),
               size=4) +
  geom_point(size=12, color="yellow", fill=alpha("yellow", 0.5), alpha=0.7, 
              shape=21, stroke=2) +
  geom_text(aes(label=n), size=4) +
  coord_flip() +
  labs(x = 'Ada yang dikenal?',
       y = 'catatan: akun @tropicanaslim banyak membalas komen orang lain',
       title = 'Siapa saja sih yang paling banyak komen di @tropicanaslim?',
       subtitle = 'sumber: 80 post terakhir dari @tropicanaslim',
       caption = 'Scraped and Visualized\n24Oct19 10:00AM\nusing R\ni k A n x') +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(size=11,face='italic'),
        axis.title = element_text(size=15),
        plot.caption = element_text(size=8,face='italic'),
        plot.title = element_text(size=20,face='bold'))
ggsave('siapa yang komen.png',width=10,height=8,dpi=450)

#analisa tags
ana.tags = data %>% select(post_id,tags) %>% group_by(post_id,tags) %>% 
  distinct()
write.csv(ana.tags,'tags.csv')
ana.tags = read.csv('tags.csv')

ana.tags %>% mutate(X=NULL,
                    tags = as.character(tags),
                    tags = gsub(' ','',tags)) %>% 
  unnest_tokens(words,tags) %>%
  count(words,sort=T) %>%
  ggplot(aes(x=reorder(words,n),y=n)) + geom_col(fill=alpha("yellow", 0.5)) +
  theme_pubclean() +
  geom_text(aes(label=n), size=2) +
  coord_flip() +
  labs(title = 'Hashtags yang Paling Sering Digunakan\noleh @tropicanaslim?',
       subtitle = 'sumber: 80 post terakhir dari @tropicanaslim',
       caption = 'Scraped and Visualized\n24Oct19 10:00AM\nusing R\ni k A n x') +
  theme(axis.title = element_blank(),
        plot.caption = element_text(size=6,face='italic'),
        plot.title = element_text(size=20,face='bold'),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.y = element_text(size=10,face='italic'))
ggsave('tags used most often.png',width=8,height=13,dpi=450)


ana.tags %>% mutate(X=NULL,
                    tags = as.character(tags),
                    tags = gsub(' ','',tags),
                    tags = gsub('\\,',' ',tags)) %>%
  unnest_tokens(bigram,tags,token='ngrams',n=2) %>%
  count(bigram,sort=T) %>% filter(bigram>1) %>%
  separate(bigram,into=c('word1','word2'),sep=' ') %>%
  graph_from_data_frame() %>%
  ggraph(layout = 'fr') +
  theme_pubclean() +
  geom_edge_link(aes(edge_alpha=n),
                 show.legend = F,
                 color='darkred') +
  geom_node_point(size=1,color='steelblue') +
  geom_node_text(aes(label=name),size=3,vjust=1,hjust=1) +
  labs(title = 'Pasangan Hashtags yang Digunakan oleh @tropicanaslim?',
       subtitle = 'sumber: 80 post terakhir dari @tropicanaslim',
       caption = 'Scraped and Visualized\n24Oct19 10:00AM\nusing R\ni k A n x') +
  theme(plot.caption = element_text(size=6,face='italic'),
        plot.title = element_text(size=20,face='bold'),
        axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank())
ggsave('pasangan tags.png',width = 12,height = 8,dpi=300)

chart.1 = 
data %>% mutate(tanggal = as.character(time)) %>% 
  separate(tanggal,into=c('tgl','time'),sep=' ') %>%
  mutate(tgl=as.Date(tgl),day=strftime(tgl,'%A')) %>%
  select(post_id,day,n_like) %>%
  distinct() %>%
  group_by(day) %>% summarise(like=sum(n_like),post=n()) %>%
  mutate(day = factor(day,levels=c('Monday','Tuesday','Wednesday',
                                   'Thursday','Friday','Saturday','Sunday'))) %>%
  ggplot(aes(x=day,y=post)) + geom_col(fill='yellow',alpha=.5) +
  geom_text(aes(label = post)) +
  theme_pubclean() +
  labs(title = 'Banyaknya post yang dilakukan @tropicanaslim',
       subtitle = 'sumber: 80 post terakhir dari @tropicanaslim',
       caption = 'Scraped and Visualized\n24Oct19 10:00AM\nusing R\ni k A n x') +
  theme(plot.caption = element_text(size=6,face='italic'),
        plot.title = element_text(size=20,face='bold'),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        axis.text.y = element_blank())

chart.2 = 
  data %>% mutate(tanggal = as.character(time)) %>% 
  separate(tanggal,into=c('tgl','time'),sep=' ') %>%
  mutate(tgl=as.Date(tgl),day=strftime(tgl,'%A')) %>%
  select(post_id,day,n_like) %>%
  distinct() %>%
  group_by(day) %>% summarise(like=sum(n_like),post=n()) %>%
  mutate(day = factor(day,levels=c('Monday','Tuesday','Wednesday',
                                   'Thursday','Friday','Saturday','Sunday'))) %>%
  ggplot(aes(x=day,y=like/post)) + geom_col(fill='yellow',alpha=.5) +
  geom_text(aes(label = round(like/post,2))) +
  theme_pubclean() +
  labs(title = 'Banyaknya like per post yang didapatkan @tropicanaslim',
       subtitle = 'sumber: 80 post terakhir dari @tropicanaslim',
       caption = 'Scraped and Visualized\n24Oct19 10:00AM\nusing R\ni k A n x') +
  theme(plot.caption = element_text(size=6,face='italic'),
        plot.title = element_text(size=20,face='bold'),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        axis.text.y = element_blank())
ggarrange(chart.1,chart.2,
          ncol=1,nrow=2)
ggsave('post per hari.png',width = 15,height = 13,dpi=600)
