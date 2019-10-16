#Scrap data dari situs www.premierleague.com
#hanya 60 alltime goalscorers

rm(list=ls())

library(dplyr)
library(rvest)
library(tidyr)
library(ggplot2)

#scrap data pemain
url = c('https://www.premierleague.com/players/89/player/overview',
        'https://www.premierleague.com/players/2064/player/overview',
        'https://www.premierleague.com/players/725/player/overview',
        'https://www.premierleague.com/players/800/player/overview',
        'https://www.premierleague.com/players/1659/player/overview',
        'https://www.premierleague.com/players/4328/player/overview',
        'https://www.premierleague.com/players/277/player/overview',
        'https://www.premierleague.com/players/1526/player/overview',
        'https://www.premierleague.com/players/1208/player/overview',
        'https://www.premierleague.com/players/462/player/overview',
        'https://www.premierleague.com/players/576/player/overview',
        'https://www.premierleague.com/players/2616/player/overview',
        'https://www.premierleague.com/players/3960/player/overview',
        'https://www.premierleague.com/players/1413/player/overview',
        'https://www.premierleague.com/players/1692/player/overview',
        'https://www.premierleague.com/players/1135/player/overview',
        'https://www.premierleague.com/players/59/player/overview',
        'https://www.premierleague.com/players/1575/player/overview',
        'https://www.premierleague.com/players/4290/player/overview',
        'https://www.premierleague.com/players/29/player/overview',
        'https://www.premierleague.com/players/338/player/overview',
        'https://www.premierleague.com/players/908/player/overview',
        'https://www.premierleague.com/players/335/player/overview',
        'https://www.premierleague.com/players/1629/player/overview',
        'https://www.premierleague.com/players/336/player/overview',
        'https://www.premierleague.com/players/2098/player/overview',
        'https://www.premierleague.com/players/2662/player/overview',
        'https://www.premierleague.com/players/533/player/overview',
        'https://www.premierleague.com/players/2845/player/overview',
        'https://www.premierleague.com/players/2553/player/overview',
        'https://www.premierleague.com/players/2117/player/overview',
        'https://www.premierleague.com/players/3247/player/overview',
        'https://www.premierleague.com/players/1768/player/overview',
        'https://www.premierleague.com/players/1909/player/overview',
        'https://www.premierleague.com/players/1005/player/overview',
        'https://www.premierleague.com/players/1217/player/overview',
        'https://www.premierleague.com/players/1249/player/overview',
        'https://www.premierleague.com/players/991/player/overview',
        'https://www.premierleague.com/players/4503/player/overview',
        'https://www.premierleague.com/players/1598/player/overview',
        'https://www.premierleague.com/players/3420/player/overview',
        'https://www.premierleague.com/players/8979/player/overview',
        'https://www.premierleague.com/players/2522/player/overview',
        'https://www.premierleague.com/players/3281/player/overview',
        'https://www.premierleague.com/players/25/player/overview',
        'https://www.premierleague.com/players/390/player/overview',
        'https://www.premierleague.com/players/1869/player/overview',
        'https://www.premierleague.com/players/239/player/overview',
        'https://www.premierleague.com/players/193/player/overview',
        'https://www.premierleague.com/players/4481/player/overview',
        'https://www.premierleague.com/players/3154/player/overview',
        'https://www.premierleague.com/players/2622/player/overview',
        'https://www.premierleague.com/players/2839/player/overview',
        'https://www.premierleague.com/players/4316/player/overview',
        'https://www.premierleague.com/players/167/player/overview',
        'https://www.premierleague.com/players/488/player/overview',
        'https://www.premierleague.com/players/6519/player/overview',
        'https://www.premierleague.com/players/4492/player/overview',
        'https://www.premierleague.com/players/342/player/overview',
        'https://www.premierleague.com/players/2040/player/overview')


n = gsub('https://www.premierleague.com/players/','',url)
n = gsub('/player/overview','',n)
url = paste('https://www.premierleague.com/players/',n,'/player/stats',sep='')

for(i in 1:length(url)){
  #nama pemain
  player = read_html(url[i]) %>% html_nodes('.t-colour') %>% html_text()
  if(length(player)>1){player = player[2]}
  
  #all stats
  all.stat = read_html(url[i]) %>% html_nodes('.allStatContainer') %>% html_text()
  all.stat = as.numeric(gsub("([0-9]+).*$", "\\1", all.stat))
  
  #all variabel
  var.awal = read_html(url[i]) %>% html_nodes('.topStat') %>% html_text()
  var.awal = gsub("[^a-zA-Z]", "", var.awal)
  all.var = read_html(url[i]) %>% html_nodes('.normalStat .stat') %>% html_text()
  all.var = gsub("[^a-zA-Z]", "", all.var)
  all.var = c(var.awal,all.var)
  
  data = data.frame(all.var,all.stat)
  data = data[-2,]
  data = data %>% pivot_wider(names_from = all.var,values_from = all.stat) %>%
    mutate(player = player)
  
  write.csv(data,paste(player,'csv',sep='.'))
}
