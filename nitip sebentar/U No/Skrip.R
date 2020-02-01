rm(list=ls())
setwd("/cloud/project/nitip sebentar/U No")

# read document
doc = docxtractr::read_docx('614789.docx')

# extract all tables
all_tbls = docxtractr::docx_extract_all_tbls(doc)

# ini copy paste dr Uga
tabel = docxtractr::docx_extract_tbl(doc,
                                     20,
                                     header=F)

# mulai iterasi pertama
i = 1
data = all_tbls[[i]]

# bikin function utk hanya ambil tabel bervariabel tiga
cek = function(i){
  temp = all_tbls[[i]]
  if(length(data)==length(temp)){
    marker = colnames(temp) == colnames(data)
    marker = sum(marker)
  } else{
    marker = 1
  }
  return(marker)
}

# contoh saat ada tabel yg tidak bervariabel tiga
cek(41)

# mulai iteresyen
for(i in 2:length(all_tbls)){
  if(cek(i) == 3){
    data = rbind(data,all_tbls[[i]])
  } else(rm(temp))
}

openxlsx::write.xlsx(data,'hasil coba-coba.xlsx')