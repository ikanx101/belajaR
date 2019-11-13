url = 'https://www.bbc.com/sport/football/22450901'

data = read_html(url) %>% html_table(fill=T)
data = data[[6]]
colnames(data) = data[1,]
data = data[-1,]
colnames(data) = janitor::make_clean_names(colnames(data))

img = png::readPNG('alex.png')

chart.1 = 
data %>% mutate(games=as.numeric(games),
                wins=as.numeric(wins),
                goals_for=as.numeric(goals_for),
                competition = factor(competition,levels = competition)) %>%
  mutate(win.rat = round(wins/games*100,2),
                goals.per.game = round(goals_for/games,2)) %>% 
  select(c('competition','win.rat','goals.per.game')) %>%
  reshape2::melt(id.vars='competition') %>%
  mutate(variable = ifelse(variable=='win.rat',
                           'Win ratio (%)',
                           'Goals per game')) %>%
  filter(competition != 'Total') %>%
  ggplot(aes(x=competition,y=value)) + 
  background_image(img) +
  geom_line(aes(group=variable,color=variable)) +
  geom_text(aes(label=value)) +
  theme_pubclean() +
  labs(title='Sir Alex Ferguson at Manchester United',
       subtitle='Source: BBC.com\nScraped and Visualized using R\ni k A n x',
       color='Parameters') +
  theme(legend.position = 'bottom',
        axis.title = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(size=30,face='bold.italic'),
        axis.text.x = element_text(angle=90,face='bold'))
  
  
chart.2 = 
  data.frame(
    player=c('Ryan Giggs','Paul Scholes','Gary Neville'),
    games=c(876,704,592)
    ) %>% 
  ggplot(aes(x=reorder(player,games),y=games)) + 
  geom_col(aes(fill=player)) +
  scale_fill_viridis_d() +
  theme_pubclean() +
  labs(title='Most used players',
       subtitle='source: football365.com')+
  geom_label(aes(label=games)) +
  theme(legend.position = 'none',
        axis.title = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(face='bold.italic')) +
  coord_flip()

chart.3 = 
  data.frame(
    player=c('Wayne Rooney','Ryan Giggs','Ruud van Nistelrooy'),
    games=c(197,154,150)
  ) %>% 
  ggplot(aes(x=reorder(player,games),y=games)) + 
  geom_col(aes(fill=player)) +
  scale_fill_viridis_d() +
  theme_pubclean() +
  labs(title='Highest goalscorers',
       subtitle='source: football365.com')+
  geom_label(aes(label=games)) +
  theme(legend.position = 'none',
        axis.title = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(face='bold.italic')) +
  coord_flip()

caption='Scraped and Visualized\nusing R\ni k A n x'

tes.1 = ggarrange(chart.1, 
                  ncol = 1, nrow = 1)
tes.2 = ggarrange(chart.2,chart.3, 
                  ncol = 2, nrow = 1)
ggarrange(tes.1,tes.2,
          ncol=1,nrow=2,
          heights = c(1,.3))
ggsave('Alex Ferguson.png',width = 10,height = 9)
