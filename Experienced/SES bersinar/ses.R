library(dplyr)
options(scipen = 99)
ses %>% 
  filter(!is.na(peng.prib)) %>% 
  mutate(ses.final = factor(ses.final,levels = c('Lower I','Middle 2','Middle 1','Upper 1','Upper 2','Super upper'))) %>% 
  group_by(ses.final) %>% 
  summarise(rata = mean(peng.prib),
            st = sd(peng.prib)) %>% 
  ggplot(aes(x = ses.final)) +
  geom_col(aes(y = rata)) +
  geom_errorbar(aes(ymin = rata-st,ymax=rata+st),width=.5) +
  geom_label(aes(y=rata,label = paste0('Rp',round(rata/1000000,1),'juta'))) +
  labs(x = 'SES',
       y = 'Pengeluaran',
       title = 'SES dari Data Riset')

ses %>% 
  filter(!is.na(peng.prib)) %>% 
  ggplot(aes(y = peng.prib)) +
  geom_boxplot()

ses = 
  ses %>% 
  filter(!is.na(peng.prib))
unique(cut(ses$peng.prib,5))
