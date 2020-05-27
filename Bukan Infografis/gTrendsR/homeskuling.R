setwd("~/Documents/belajaR/Bukan Infografis/gTrendsR")

rm(list = ls())

library(gtrendsR)
library(dplyr)
library(ggplot2)

data = gtrends('homeschooling',geo = 'ID')

# data pertama
data_1 = data$interest_over_time
data_1 %>%
  ggplot(aes(x = date,
             y = hits)) +
  geom_line(color = 'steelblue') +
  geom_smooth(method = 'loess',color = 'darkred') +
  labs(title = 'Trend Pencarian Homeschooling di Indonesia',
       subtitle = 'sumber: Google Trends Indonesia per 27 May 2020 19:18',
       x = 'Tanggal',
       y = 'Hits',
       caption = 'Scraped and Visualized\nusing R\nikanx101.github.io') +
  theme_minimal() +
  theme(axis.text.y = element_blank())
ggsave('Trends.png',width = 9,height = 7,dpi = 450)

# data kedua
data_2 = data$interest_by_city
data_2 %>%
  filter(!is.na(hits)) %>%
  group_by(location) %>%
  summarise(hits = mean(hits)) %>%
  ggplot(aes(x = reorder(location,hits),
             y = hits)) +
  geom_col(fill = 'white',
           color = 'black',
           size = 1.25) +
  labs(title = 'Kota yang Paling Banyak Mencari Homeschooling di Indonesia',
       subtitle = 'sumber: Google Trends Indonesia per 27 May 2020 19:18',
       x = 'Kota',
       y = 'Hits',
       caption = 'Scraped and Visualized\nusing R\nikanx101.github.io') +
  theme_minimal() +
  theme(axis.text.y = element_blank())
ggsave('City.png',width = 9,height = 7,dpi = 450)
  
# data ketiga
data_3 = data$related_queries
