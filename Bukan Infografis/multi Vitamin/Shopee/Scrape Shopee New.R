setwd("~/Documents/belajaR/Bukan Infografis/multi Vitamin/Shopee")
rm(list=ls())
library(rvest)
library(dplyr)

url = "Enervon c isi 100 tablet _ Shopee Indonesia.html"

# Fungsi Utama
scrape_donk = function(link){
  read_html(link) %>% {
    tibble(
    seller = html_nodes(.,"._3Lybjn") %>% html_text(),
    nama = html_nodes(.,".qaNIZv span") %>% html_text(),
    harga = html_nodes(.,"._3n5NQx") %>% html_text(),
    terjual = html_nodes(.,"._22sp0A") %>% html_text(),
    merek = html_nodes(.,"._2H-513") %>% html_text(),
    kategori = html_nodes(.,"#main > div > div._1Bj1VS > div.page-product > div.container > div:nth-child(3) > div.page-product__content > div.page-product__content--left > div.product-detail.page-product__detail > div:nth-child(1) > div._2aZyWI > div:nth-child(1) > div > a:nth-child(5)
") %>% html_text(),
    asal = html_nodes(.,"._3yhtIY") %>% html_text()
    )
  }
}
data = scrape_donk(url)