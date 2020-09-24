rm(list=ls())

library(dplyr)
library(tidyr)

load("hasil scrape.rda")

data = 
  raw %>% 
  filter(grepl("terjual",terjual,ignore.case = T)) %>% 
  mutate(harga = gsub("\\.","",harga),
         harga = gsub("Rp","",harga),
         terjual = gsub("\\.","",terjual),
         terjual = gsub("[A-Z,a-z]","",terjual),
         harga = trimws(harga),
         terjual = trimws(terjual),
         harga = as.numeric(harga),
         terjual = as.numeric(terjual),
         omset = harga*terjual) %>% 
  rename(qty = terjual) %>% 
  filter(harga > 500,
         !grepl("arloji",nama,ignore.case = T),
         !grepl("bukan kw",nama,ignore.case = T),
         !grepl("sandaran buku",nama,ignore.case = T),
         !grepl("KERTOSOEWIRJO NII KW",nama,ignore.case = T),
         !grepl("Gameboy Repro Manual book",nama,ignore.case = T),
         !grepl("Buku Gambar",nama,ignore.case = T)
         ) %>% 
  distinct()

save(data,file = "clean.rda")