rm(list = ls())

library(gtrendsR)
library(dplyr)
library(ggplot2)

data = gtrends(c('new normal','new world order','konspirasi'),geo = 'ID')
save(data,file = 'scraped data.rda')
data_1 = data[[1]]
data_1 %>% 
  mutate(hits = gsub('<1',0.5,hits),
         hits = as.numeric(hits),
         tahun = lubridate::year(date),
         bulan = lubridate::month(date)) %>% 
  filter(tahun == 2020) %>% 
  filter(bulan > 4) %>% 
  ggplot(aes(x = date,
             y = hits)) +
  geom_line(aes(color = keyword),size = 1.25) +
  ggrepel::geom_text_repel(aes(label = hits,color = keyword),size=3) +
  labs(title = 'Google Trends: Indonesia',
       subtitle = 'Apakah konspirasi ngetrend di sini?',
       caption = 'Scraped and Visualized\nusing R\nikanx101.github.io',
       x = 'Tahun 2020',
       y = 'Relative Hits',
       color = 'Keywords') +
  theme_replace()
ggsave('new normal.png',width = 7, height = 5,dpi = 850)