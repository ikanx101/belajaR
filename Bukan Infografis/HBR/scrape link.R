# jangan lupa setwd yah

rm(list=ls())

library(rvest)
library(dplyr)

data_1 = data.frame(
  kategori = "leadership",
  links = c("https://hbr.org/2020/09/3-ways-to-motivate-your-team-through-an-extended-crisis",
            "https://hbr.org/2020/09/gravitas-is-a-quality-you-can-develop",
            "https://hbr.org/2020/09/is-ceo-a-two-person-job",
            "https://hbr.org/2020/09/4-strengths-of-family-friendly-work-cultures",
            "https://hbr.org/2020/09/dont-just-lead-your-people-through-trauma-help-them-grow",
            "https://hbr.org/2020/09/5-principles-to-guide-adaptive-leadership",
            "https://hbr.org/2020/09/inside-twitters-response-to-the-covid-19-crisis")
)

data_2 = data.frame(
  kategori = "technology",
  links = c("https://hbr.org/2020/09/are-you-ready-for-tech-that-connects-to-your-brain",
            "https://hbr.org/2020/09/how-to-make-3d-printing-better",
            "https://hbr.org/2020/09/how-to-harness-the-digital-transformation-of-the-covid-era",
            "https://hbr.org/2020/09/the-next-big-breakthrough-in-ai-will-be-around-language",
            "https://hbr.org/2020/09/ai-should-change-what-you-do-not-just-how-you-do-it",
            "https://hbr.org/2020/09/how-green-is-your-software",
            "https://hbr.org/2020/09/is-vr-the-future-of-corporate-training")
)

data = rbind(data_1,data_2)

scrape = function(url){
  read_html(url) %>% html_nodes("p") %>% html_text(trim = T)
}

data = data %>% mutate(baca = sapply(links, scrape))

for(i in 1:length(data$links)){
  tes = data$baca[[i]]
  tes = unlist(tes)
  tes = stringr::str_c(tes,collapse = " ")
  data$baca_new[i] = tes
}

data$baca = NULL

save(data,file = "artikel hbr.rda")