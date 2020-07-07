rm(list=ls())
library(dplyr)


simulasi = function(n_tes){
  n = 200 #pengulangan
  n_sakit = 15 #banyak orang sakit 
  total = 200 # total karyawan
  temp = c(0)
  for(i in 1:n){
    karyawan = sample(c(1,0),total,prob = c(n_sakit/total,(total-n_sakit)/total),replace = T)
    tes = sample(karyawan,n_tes)
    hasil = sum(tes)
    hasil = ifelse(hasil>1,1,0)
    temp = c(temp,hasil)
  }
  sum(temp)/n*100
}

data = data.frame(n_tes = c(1:200))

data$sensitivity = sapply(data$n_tes,simulasi)

library(ggplot2)


data %>% 
  ggplot(aes(x = n_tes,
             y = sensitivity)) +
  geom_smooth(method = 'loess') +
  geom_line(color = 'black') +
  labs(title = 'Berapa banyak karyawan yang harus dites?',
       subtitle = '\nDi suatu pabrik berisi 400 orang. Diduga ada 15 orang yang terpapar Covid 19.\nMonteCarlo Simulation 80.000 times.',
       caption = 'Simulated and Visualized\nusing R\nikanx101.github.io',
       x = 'Banyak tes',
       y = 'Peluang mendapat karyawan yang positif\n') +
  ggthemes::theme_economist() +
  theme(axis.text = element_text(size=10))
ggsave('hasil sim.png',width = 8,height=5,dpi=450)
