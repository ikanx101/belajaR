rm(list=ls())

library(polite)
library(rvest)
library(dplyr)

link = readLines("links.txt")

# polite function
scrape_donk = function(url){
  session = bow(url, 
                user_agent = "market research",
                force = TRUE)
  
  data = 
    read_html(session$url) %>% 
    {tibble(
      resep = html_nodes(.,".field-group--no-container-xs") %>% html_text(),
      bahan = html_nodes(.,"#ingredients div") %>% html_text()
    )} 
  
  data = 
    data %>% 
    mutate(resep = gsub("\\\n","",resep),
           bahan = gsub("\\\n","",bahan),
           resep = stringr::str_trim(resep),
           bahan = stringr::str_trim(bahan),
           penanda = stringr::str_length(bahan)) %>% 
    filter(penanda < 30) %>% 
    filter(penanda > 11) %>% 
    mutate(penanda = NULL)
  return(data)
}

i = 1
data = scrape_donk(link[i])
    
for(i in 33:length(link)){
  closeAllConnections()
  Sys.sleep(50)
  temp = scrape_donk(link[i])
  data = rbind(data,temp)
  print(i)
}

save(data,file = "resep.rda")
write.csv(data,"20 resep cookpad.csv")