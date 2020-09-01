rm(list=ls())

data = read.csv("EPL.csv")

library(dplyr)

data = janitor::clean_names(data)

data = 
  data %>% 
  mutate(date = as.Date(date,format = "%d/%m/%Y"),
         kondisi = ifelse(date <= "2020-03-09","Pre COVID","COVID"),
         ftr = case_when(ftr == "A" ~ "Away team menang",
                         ftr == "D" ~ "Seri",
                         ftr == "H" ~ "Home team menang"),
         ftr = factor(ftr, levels = c("Away team menang",
                                      "Seri",
                                      "Home team menang")),
         kondisi = factor(kondisi, levels = c("Pre COVID","COVID")))

library(ggplot2)
library(ggpubr)

new = 
  data %>% 
  group_by(kondisi,ftr) %>% 
  summarise(freq = n()) %>% 
  ungroup() %>% 
  group_by(kondisi) %>% 
  mutate(all_matches = sum(freq),
         persen = freq/all_matches*100,
         persen = round(persen,1),
         persen = paste0(persen,"%"))

match_pre = max(new$all_matches)
match_cov = min(new$all_matches)

new %>% 
  filter(kondisi == "Pre COVID") %>% 
  ggplot(aes(x = "",
             y = freq,
             fill = ftr)) +
  geom_bar(stat = "identity") +
  scale_fill_brewer(palette="Set2") +
  coord_polar("y", start=0) +
  ggrepel::geom_label_repel(aes(label = paste(ftr,persen,sep = "\n")),position = position_stack(vjust = 0.5)) +
  theme_pubclean() +
  theme(panel.grid=element_blank(),
        panel.background = element_blank(),
        axis.title=element_blank(),
        legend.position = 'none',
        axis.text = element_blank(),
        axis.ticks = element_blank()) +
  labs(title = "Kondisi Pertandingan Sebelum COVID",
       subtitle = "Data English Premier League 2019/2020",
       caption = paste0("base: ",match_pre," pertandingan"))

new %>% 
  filter(kondisi == "COVID") %>% 
  ggplot(aes(x = "",
             y = freq,
             fill = ftr)) +
  geom_bar(stat = "identity") +
  scale_fill_brewer(palette="Set2") +
  coord_polar("y", start=0) +
  ggrepel::geom_label_repel(aes(label = paste(ftr,persen,sep = "\n")),position = position_stack(vjust = 0.5)) +
  theme_pubclean() +
  theme(panel.grid=element_blank(),
        panel.background = element_blank(),
        axis.title=element_blank(),
        legend.position = 'none',
        axis.text = element_blank(),
        axis.ticks = element_blank()) +
  labs(title = "Kondisi Pertandingan Saat COVID",
       subtitle = "Data English Premier League 2019/2020",
       caption = paste0("base: ",match_cov," pertandingan"))

new %>% 
  ggplot(aes(x = ftr,
             y = freq)) +
  geom_col(aes(fill = freq)) + 
  geom_label(aes(label = paste0("n: ",freq,"\nPercent: ",persen),
                 fill = freq),
             color = "white",
             size = 2) +
  scale_fill_gradient(low = "steelblue",high = "darkred") +
  facet_wrap(~kondisi) +
  ggthemes::theme_wsj() +
  theme(axis.text.y = element_blank(),
        legend.position = "none",
        plot.title = element_text(size = 18),
        plot.subtitle = element_text(size = 12)) +
  labs(title = "Perbandingan Pemenang Laga Sebelum dan Saat COVID",
       subtitle = "Data English Premier League 2019/2020")

# home menang
hasil = prop.test(c(43,129),c(92,288))
ifelse(hasil$p.value<0.05,"Tolak H0","H0 tidak ditolak")

# draw
hasil = prop.test(c(20,72),c(92,288))
ifelse(hasil$p.value<0.05,"Tolak H0","H0 tidak ditolak")

# away menang
hasil = prop.test(c(29,87),c(92,288))
ifelse(hasil$p.value<0.05,"Tolak H0","H0 tidak ditolak")


## Sekarang pake Goals
data %>% 
  group_by(kondisi) %>% 
  summarise(gol_home = mean(fthg),
            sd_home = sd(fthg),
            gol_away = mean(ftag),
            sd_away = sd(ftag)) %>% 
  ggplot() +
  geom_col(aes(x = kondisi,
               y = gol_home)) +
  geom_errorbar(aes(x = kondisi,
                    ymin = gol_home - sd_home,
                    ymax = gol_home + sd_home),width = .1)

data %>% 
  group_by(kondisi) %>% 
  summarise(gol_home = mean(fthg),
            sd_home = sd(fthg),
            gol_away = mean(ftag),
            sd_away = sd(ftag)) %>% 
  ggplot() +
  geom_col(aes(x = kondisi,
               y = gol_away)) +
  geom_errorbar(aes(x = kondisi,
                    ymin = gol_away - sd_away,
                    ymax = gol_away + sd_away),width = .1)


# cek home
test_1 = t.test(fthg~kondisi,data)
ifelse(test_1$p.value<0.05,"Tolak H0","H0 tidak ditolak")
# cek away
test_2 = t.test(ftag~kondisi,data)
ifelse(test_2$p.value<0.05,"Tolak H0","H0 tidak ditolak")



# library fit dist
library(fitdistrplus)
descdist(data$ftag,discrete = T)
fitdist(tes, 'logis')