rm(list=ls())

library(ggplot2)
library(dplyr)
library(ggthemes)
library(ggpubr)
library(rvest)

tanggal = paste0('Jan. ',c(23:31))
tanggal = c(tanggal,paste0('Feb. ',c(1:9)))

# chart 1
url = 'https://www.worldometers.info/coronavirus/coronavirus-cases/'

tabel = read_html(url) %>% html_table(fill=T)
data = tabel[[1]]
colnames(data) = janitor::make_clean_names(colnames(data))
data_1 = data %>% 
  mutate(total_cases = gsub('\\,','',total_cases),
         total_cases = as.numeric(total_cases))
data_1 = data_1[-3:-4]

# chart 2
url = 'https://www.worldometers.info/coronavirus/coronavirus-death-toll/'

tabel = read_html(url) %>% html_table(fill=T)
data = tabel[[1]]
colnames(data) = janitor::make_clean_names(colnames(data))
data_2 = data %>% 
  mutate(total_deaths = gsub('\\,','',total_deaths),
         total_deaths = as.numeric(total_deaths))
data_2 = data_2[-3:-4]

gabung = merge(data_1,data_2)

chart_1 = 
gabung %>% reshape2::melt(id.vars='date') %>%
  mutate(variable = case_when(variable == 'total_cases' ~ 'Total Cases',
                              variable == 'total_deaths' ~ 'Total Deaths')) %>%
  ggplot(aes(x=factor(date,levels = tanggal),
             y=value,group = variable)) + 
  geom_line(aes(color = variable)) +
  geom_label(aes(label = value,color=variable),size=3) +
  theme_minimal() +
  labs(title = 'Novel Coronavirus: Cases vs Death',
       subtitle = 'source: https://www.worldometers.info/coronavirus',
       caption = 'Scraped and Visualized\nusing R\n@mr.ikanx',
       color = 'Parameter') +
  theme(axis.title = element_blank(),
        axis.text.y = element_blank(),
        plot.title = element_text(size=20),
        legend.position = 'bottom')

# chart 3
url = 'https://www.worldometers.info/coronavirus/countries-where-coronavirus-has-spread/'
tabel = read_html(url) %>% html_table(fill=T)
data = tabel[[1]]
colnames(data) = janitor::make_clean_names(colnames(data))
data_3 = data %>% 
  mutate(cases = gsub('\\,','',cases),
         cases = as.numeric(cases))

chart_2 = 
data_3 %>% select(country,cases,deaths) %>% 
  reshape2::melt(id.vars='country') %>%
  mutate(variable = case_when(variable == 'cases' ~ 'Total Cases',
                              variable == 'deaths' ~ 'Total Deaths')) %>%
  ggplot(aes(x=reorder(country,-value),
             y=value)) + 
  geom_col() +
  geom_label(aes(label = value),size=3) +
  facet_wrap(~variable,nrow = 2,ncol = 1) +
  theme_minimal() +
  labs(title = 'Novel Coronavirus: Countries where the Coronavirus has spread',
       subtitle = 'source: https://www.worldometers.info/coronavirus',
       caption = 'Scraped and Visualized\nusing R\n@mr.ikanx',
       color = 'Parameter') +
  theme(axis.title = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_text(angle=90),
        plot.title = element_text(size=20))


ggarrange(chart_1,chart_2,ncol = 2,
          nrow=1,
          widths = c(1.5,1))
ggsave('Corona.png',width =20,height = 9)
