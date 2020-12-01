rm(list=ls())

library(readxl)
library(dplyr)
library(tidyr)

data = read_excel("Database_Geo_IDN_Tableau_Extract.xlsx")
save_dulu = colnames(data)
data = janitor::clean_names(data)

data = 
  data %>% 
  mutate(kelurahan_label = ifelse(is.na(kelurahan_label),"NA",kelurahan_label)) %>% 
  fill(provinsi_label,kota_kab_level,kecamatan_label,kelurahan_label,gid_4,.direction = "down")

length(unique(data$kelurahan_label))

colnames(data) = save_dulu

openxlsx::write.xlsx(data,file = "Dbase_Geo_New_v2.xlsx")