library(RSelenium)

<<<<<<< HEAD
setwd("~/Documents/belajaR/Bukan Infografis/multi Vitamin/Tokopedia/saved html")
pages = list.files(pattern = "html")
=======
#binman::rm_platform("phantomjs")
#wdman::selenium(retcommand = TRUE)
>>>>>>> faf83630b62d70a0baf4c4935b1c5ad72c0c0f7d

driver <- rsDriver(port=4446L,browser="chrome")
remote_driver <- driver$client

links = readLines("https://raw.githubusercontent.com/ikanx101/belajaR/master/Bukan%20Infografis/multi%20Vitamin/Tokopedia/link%20final.txt")


scrape_selenium = function(link){
  remote_driver$navigate(link)
  
  nama = remote_driver$findElement(using = 'css selector',".css-v7vvdw")
  nama = unlist(nama$getElementText())
  harga = remote_driver$findElement(using = 'css selector',".price")
  harga = unlist(harga$getElementText())
  terjual = remote_driver$findElement(using = 'css selector',".items div:nth-child(1)")
  terjual = unlist(terjual$getElementText())
  toko = remote_driver$findElement(using = 'css selector',"#pdp_comp-shop_credibility h2")
  toko = unlist(toko$getElementText())
  
  hasil_data = data.frame(nama,harga,terjual,toko)
  return(hasil_data)
  Sys.sleep(3)
}

<<<<<<< HEAD
raw = rbind(raw,data)
setwd("~/Documents/belajaR/Bukan Infografis/multi Vitamin/Tokopedia")
save(raw,file = 'hasil scrape.rda')
=======
scrape_selenium(url)
>>>>>>> faf83630b62d70a0baf4c4935b1c5ad72c0c0f7d
