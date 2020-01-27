setwd("/cloud/project/Bukan Infografis/puzzles/Puzzle Deadly Blocks")
rm(list=ls())

lempar_dadu = sample(6,15,replace = TRUE)
posisi_bidak = cumsum(lempar_dadu)
data = data.frame(lempar_dadu,
                  posisi_bidak,
                  under_30 = posisi_bidak<=32) %>% 
  filter(under_30==T)
posisi_bidak = data$posisi_bidak

posisi_1 = posisi_bidak

for(i in 2:100000){
  lempar_dadu = sample(6,15,replace = TRUE)
  posisi_bidak = cumsum(lempar_dadu)
  data = data.frame(lempar_dadu,
                    posisi_bidak,
                    under_30 = posisi_bidak<=32) %>% 
    filter(under_30==T)
  posisi_bidak = data$posisi_bidak
  posisi_2 = posisi_bidak
  posisi_1 = c(posisi_1,posisi_2)
}

data = data.frame(id=c(1:length(posisi_1)),posisi_bidak = posisi_1) 

save(data,'hasil run.rda')