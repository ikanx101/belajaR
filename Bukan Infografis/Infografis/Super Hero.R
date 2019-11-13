#Scrap data dari superherodb.com

rm(list=ls())
library(devtools)
source_url('https://raw.githubusercontent.com/ikanx101/belajaR/master/All%20Func.R')

library(rvest)
#page 1 dari situs utama
url='https://www.superherodb.com/characters'
links = read_html(url) %>% html_nodes('a') %>% html_attr('href')
links=paste('https://www.superherodb.com',links[25:274],sep='')
n=length(links)

i = 1
names = read_html(links[i]) %>% html_nodes('h1') %>% html_text()
label_1 = read_html(links[i]) %>% html_nodes('label') %>% html_text()
value_1 = read_html(links[i]) %>% html_nodes('.stat-value') %>% html_text()
names = read_html(links[i]) %>% html_nodes('h1') %>% html_text()
label_2 = read_html(links[i]) %>% html_nodes('.table-label') %>% html_text()
value_2 = read_html(links[i]) %>% html_nodes('.table-label+ td') %>% html_text()
superpowers = read_html(links[i]) %>% html_nodes('.col-12 .chip') %>% html_text()

data = data.frame(var=c(label_1,label_2),val=c(value_1,value_2))
data = pivot_wider(data,names_from = var,values_from = val) %>%
  mutate(names=names,super.powers=list(superpowers))

for(i in 2:n){
  names = read_html(links[i]) %>% html_nodes('h1') %>% html_text()
  label_1 = read_html(links[i]) %>% html_nodes('label') %>% html_text()
  value_1 = read_html(links[i]) %>% html_nodes('.stat-value') %>% html_text()
  names = read_html(links[i]) %>% html_nodes('h1') %>% html_text()
  label_2 = read_html(links[i]) %>% html_nodes('.table-label') %>% html_text()
  value_2 = read_html(links[i]) %>% html_nodes('.table-label+ td') %>% html_text()
  superpowers = read_html(links[i]) %>% html_nodes('.col-12 .chip') %>% html_text()
  
  dummy = data.frame(var=c(label_1,label_2),val=c(value_1,value_2))
  dummy = pivot_wider(dummy,names_from = var,values_from = val) %>%
    mutate(names=names,super.powers=list(superpowers))
  data = bind_rows(data,dummy)
}

data$Strength = gsub('\\,','',data$Strength)
data$Strength = as.numeric(data$Strength)
save(data,file='page 1.rda') #ini page pertama
