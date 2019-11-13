rm(list = ls())
setwd('D:/Project_R/Jakarta Eye Center/New folder')

library(rvest)
library(tidyr)
library(ggplot2)
library(dplyr)
library(ggpubr)
library(ggthemes)

url = list.files()
url = data.frame(no=c(1:length(url)),url = url) %>% filter(grepl('html',url))
url = as.character(url$url)

scrap = function(url){
  data = read_html(url) %>% {
    tibble(
      nama = html_nodes(.,'.name a') %>% html_text(),
      specialties = html_nodes(.,'.name p') %>% html_text(),
      link = html_nodes(.,'.name a') %>% html_attr('href')
    )
  } 
  
  data = data %>% mutate(specialties = gsub('\\n','',specialties),
                  specialties = gsub('\\t','',specialties),
                  location = 'x')
  return(data)
}

data = scrap(url[1])
for(i in 2:length(url)){
  temp = scrap(url[i])
  data = rbind(data,temp)
}


for(i in 1: length(data$link)){
  data$location[i] = list(read_html(data$link[i]) %>% html_nodes('.data-schedule p') %>% 
    html_text())
}

setwd('D:/Project_R/Jakarta Eye Center')
################
#ambil specialist yah
sp = data %>% select(nama,specialties) %>%
  mutate(specialties = strsplit(specialties,'\\,')) %>% 
  unnest_wider(specialties) %>% distinct()
nama.var=c(paste('var',c(1:(length(sp)-1)),sep='.'))
colnames(sp) = c('nama',nama.var)
sp = sp %>% reshape2::melt(id.vars='nama') %>% mutate(variable=NULL) %>% 
  distinct() %>%
  filter(!is.na(value))

#kita bikin chart pertama dulu
#img = png::readPNG('alex.png')
#background_image(img)
chart.1 = 
sp %>% group_by(value) %>% summarise(n=n()) %>%
  ggplot(aes(x=reorder(value,-n),y=n)) + 
  geom_col(color = 'lightblue',fill=alpha('lightblue',.5),size=1) + 
  geom_label(aes(label=n),size=2.5) +
  theme_minimal() +
  labs(title='Spesialisasi Dokter Mata yang Praktek di JEC',
       subtitle = 'Sumber: situs jec.co.id') +
  theme(plot.title = element_text(size=17,face='bold'),
        plot.subtitle = element_text(size=14,face='bold.italic'),
        axis.title = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_text(angle=90,size=9))

################
#ambil rs yah
rs = data %>% select(nama,location) %>%
  unnest_wider(location) %>% distinct()
nama.var=c(paste('var',c(1:(length(rs)-1)),sep='.'))
colnames(rs) = c('nama',nama.var)
rs = rs %>% reshape2::melt(id.vars='nama') %>% mutate(variable=NULL) %>% 
  distinct() %>%
  filter(!is.na(value))

#bikin chart per rs yah
chart.2 = 
rs %>% group_by(value) %>% summarise(n=n()) %>%
  ggplot(aes(x=reorder(value,-n),y=n)) + 
  geom_col(color = 'lightblue',fill=alpha('lightblue',.5),size=1) + 
  geom_label(aes(label=n),size=2.5) +
  theme_minimal() +
  labs(title='Banyaknya Dokter Mata yang Praktek per Lokasi JEC',
       subtitle = 'Sumber: situs jec.co.id') +
  theme(plot.title = element_text(size=17,face='bold'),
        plot.subtitle = element_text(size=14,face='bold.italic'),
        axis.title = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_text(angle=90,size=9))

#kita bikin cross tabulasinya yah
colnames(sp)[2] = 'sp'
colnames(rs)[2] = 'rs'
final = merge(sp,rs)
chart.3 = 
final %>% group_by(rs,sp) %>% summarise(n=n()) %>%
  graph_from_data_frame() %>%
  ggraph(layout = 'linear',circular=T) +
  theme_pubclean() +
  geom_edge_arc(aes(edge_alpha=n),
                 show.legend = F,
                 color='steelblue') +
  geom_node_point(size=1,color='steelblue') +
  geom_node_text(aes(label=name),check_overlap = T,repel=T,size=4,angle=45) +
  theme_void()
ggsave('JEC linked.png',width = 15,height = 13)

chart.4 = 
  final %>% group_by(rs,sp) %>% summarise(n=n()) %>%
  ggplot(aes(x=reorder(rs,-n),y=n,fill=sp)) +
  geom_col() +
  theme_pubclean() +
  labs(title='Banyaknya Dokter Mata yang Praktek per Lokasi JEC',
       subtitle = 'Sumber: situs jec.co.id',
       caption = 'Scraped and Visualized\nusing R\ni k A n x',
       fill = 'Specialties') +
  theme(plot.title = element_text(size=17,face='bold'),
        plot.subtitle = element_text(size=14,face='bold.italic'),
        plot.caption = element_text(size=11,face='italic'),
        axis.title = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_text(size=9),
        legend.position = 'bottom')

final.1 = ggarrange(chart.1,chart.2,
                    ncol = 2,
                    nrow = 1)
final.3 = ggarrange(final.1,chart.4,
                    ncol = 1,
                    nrow = 2,
                    heights = c(1,1.9))
ggsave(final.3,file='JEC.png',width = 15,height = 13)
