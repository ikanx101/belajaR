rm(list=ls())
#generate data
#tujuan
# qty = 0.6 * harga + 21

id = c(1:150)
harga = sample(seq(15,22,.1),150,replace=T)
qty = (-0.6 * harga + sample(seq(20,23,.1),150,replace=T))*(sample((77:80),150,replace=T)/100)

data = data.frame(id,harga,qty)
id.selected = sample(150,60,replace=F)
data.final = data %>% filter(id %in% id.selected)
plot(data.final$harga,data.final$qty)

write.csv(data.final,'latihan regresi.csv')
