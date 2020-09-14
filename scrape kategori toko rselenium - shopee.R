library(RSelenium)

rD <- rsDriver(browser=c("firefox"))
driver <- rD$client


link = paste('https://shopee.co.id/shop/',url$shop_id[1],sep = "")
driver$navigate(link)

temp_cat = data.frame(NULL)
all_data = data.frame(NULL)


for(i in 1:nrow(url)) { #URL adalah dataframe yang isinya shop_id
  flag = TRUE
  temp_cat = data.frame(NULL)
  link = paste('https://shopee.co.id/shop/',url$shop_id[i],sep = "")
  driver$navigate(link)
  
  while(flag) {
    Sys.sleep(1)
    tryCatch(
      {
        a <- driver$findElement("xpath","//div[@class='shopee-category-list__body']")
        b <- a$findChildElements("xpath","//div[@class='shopee-category-list__sub-category']")
        flag = FALSE
      },error = function(e){}
    )
  }
  
  a <- driver$findElement("xpath","//div[@class='shopee-category-list__body']")
  b <- a$findChildElements("xpath","//div[@class='shopee-category-list__sub-category']")
  for(j in 1:length(b)){
    xpath <- paste("//div[@class='shopee-category-list__sub-category'][",j,"]")
    temp = data.frame(kat = driver$findElement("xpath",xpath)$getElementText()[[1]])
    temp_cat = rbind(temp_cat, temp)
  }
  
  nama_toko = driver$findElement("xpath","//h1[@class='section-seller-overview-horizontal__portrait-name']")$getElementText()[[1]]
  
  print(paste0('Data ke ',i,' dengan Nama Toko ',nama_toko,' Done'))
  
  temp = 
    data.frame(
      nama_toko = nama_toko,
      kategori = temp_cat
    )
  
  all_data = rbind(all_data, temp)
  
}
