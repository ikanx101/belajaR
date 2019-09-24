rm(list=ls())
setwd('D:/Project_R/TelegramBOT')
library(telegram.bot)
library(telegram)
library(readxl)
library(rvest)
library(ggplot2)
library(dplyr)
updater <- Updater(token = bot_token("RTelegramBot"))
bot <- TGBot$new(token = bot_token('RTelegramBot'))

# Get bot info
print(bot$getMe())

# Get updates
update <- bot$getUpdates()

##########################
#start
start <- function(bot, update){
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = paste('Hai Kak ',update$message$from$first_name,', perkenalkan saya i.k.a.n.x_bot_ver_1.1\nSilakan tanyakan tentang machine learning, artificial intelligence, atau apapun itu ya... #projectiseng\nContoh: Apa itu machine learning?\nCari tahu harga emas saat ini, ketik /emas',sep=''))
}

start_handler <- CommandHandler('start', start)
updater <- updater + start_handler

##########################
#harga emas
cari <- function(bot, update){
  url='https://harga-emas.org/1-gram/'
  txt = read_html(url) %>% html_nodes('td') %>% html_text()
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = paste('Pada ',txt[13],', per 1 gram emas harganya Rp',txt[11],sep=''))
}
start_handler <- CommandHandler('emas', cari)
updater <- updater + start_handler

##########################
#kurs rupiah
cari <- function(bot, update){
  url='https://harga-emas.org/1-gram/'
  txt = read_html(url) %>% html_nodes('td') %>% html_text()
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = paste('Pada ',txt[13],', per 1 USD nilai tukarnya adalah Rp',txt[8],sep=''))
}
start_handler <- CommandHandler('rupiah', cari)
updater <- updater + start_handler


##########################
#karhutla
cari <- function(bot, update){
  url='http://sipongi.menlhk.go.id/hotspot/matrik_tahunan'
  data = read_html(url) %>% html_table(fill=T)
  data = data[[1]]
  data = reshape2::melt(data,id.vars='Provinsi')
  data$value = as.numeric(data$value)
  prov = data %>% filter(variable=='Sep') %>% filter(!is.na(value)) %>% arrange(value) %>% tail(5)
  prov = prov$Provinsi
  bulan = c('Jul','Agu','Sep')
  judul = print(Sys.time())
  judul = gsub(' +07','',judul,fixed = T)
  data %>% filter(variable %in% bulan) %>% filter(Provinsi %in% prov) %>% ggplot(aes(x=variable,y=value,group=Provinsi)) +
    theme_minimal() + 
    geom_line(aes(color=Provinsi,linetype=Provinsi),size=1.5) + geom_label(aes(label=value,color=Provinsi),size=3) +
    labs(title = 'TOP 5 Provinsi dengan Titik Panas Terbanyak',subtitle=paste('source: SIPONGI KemenLHK pada ',judul,sep='')) +
    theme(axis.title.x = element_blank(),axis.text.y = element_blank()) + labs(y='Banyak Titik Panas') +
    theme(plot.title = element_text(face='bold',size=20),plot.subtitle = element_text(face='italic',size=13)) +
    labs(caption = 'Scrapped Real Time using R\ni k A n X')
  ggsave('sipongi.png',width = 10,height = 4.5,dpi = 450)
  bot$sendPhoto(
    chat_id = update$message$chat_id,
    photo = 'D:/Project_R/TelegramBOT/sipongi.png',
    caption = "Data Real Time dari SIPONGI KemenLHK"
  )
}
start_handler <- CommandHandler('karhutla', cari)
updater <- updater + start_handler


##########################
#detik.com
cari <- function(bot, update){
  url='https://www.detik.com/'
  webpage <- read_html(url)
  links <- webpage %>% html_nodes("a") %>% html_attr("href")
  judul <- webpage %>% html_nodes("a") %>% html_text()
  data = data.frame(judul,links)
  data = data[26:30,]
  for(i in 1:5){
    artikel = read_html(as.character(data$links[i])) %>% html_nodes("#detikdetailtext") %>% html_text()
    hapus = c('\n','\t','\r','googletag display div gpt ad','googletag.cmd.push','googletag.display',
              'function()',"('div-gpt-ad-1535944306169-0')","Gambas:Video 20detik",
                '1535944519982 0 ','\\{','\\}','\\;','msh','  ','  ','  ','  ','  ')
    for(j in 1:length(hapus)){
      artikel = gsub(hapus[j],' ',artikel)
    }
    bot$sendMessage(chat_id = update$message$chat_id,
                    text = paste(data$judul[i],'\n',artikel,'\n\n\n',data$links[i]))
  }
}
start_handler <- CommandHandler('detik', cari)
updater <- updater + start_handler
##########################

tolong.donk = function(judul){
  judul=tolower(judul)
  judul=gsub('_','',judul)
  judul=gsub('-','',judul)
  judul=gsub('\\,','',judul)
  judul=gsub('\\?','',judul)
  judul=gsub('\\!','',judul)
  judul=gsub('\\|','',judul)
  judul=gsub('sih','',judul)
  judul=gsub('..','',judul,fixed=T)
  return(judul)
}

#Fungsi data grepl
start_handler <- function(bot, update){
  text <- "Saya masih belum belajar itu... Maklum #projectiseng, mau bantu develop bot ini? hehehe.\nTry: `Apa itu machine learning?`\n Try: `Apa itu algoritma?`\natau ketik: /start /emas /rupiah /detik\n\n\natau silakan berkunjung ke blog saya di: https://passingthroughresearcher.wordpress.com/"
  data = read_excel('bank data.xlsx',sheet = 'grepl')
  for(i in 2:length(data$v1)){
    if(grepl(data$v1[1],tolong.donk(update$message$text),ignore.case = T)){text=data$v2[1]}
    else if (grepl(data$v1[i],tolong.donk(update$message$text),ignore.case = T)){text=print(data$v2[i])}
  }
  datum = read_excel('bank data.xlsx',sheet = 'ifelse')
  for(i in 2:length(datum$v1)){
    if(tolong.donk(update$message$text) == datum$v1[1]){text=datum$v2[1]}
    else if (tolong.donk(update$message$text) == datum$v1[i]){text=print(datum$v2[i])}
  }
  bot$sendMessage(chat_id = update$message$chat_id, text = text)
  bot$sendMessage(chat_id = 826276159, text = update$message$text)
}
updater <- updater + MessageHandler(start_handler, MessageFilters$text)

updater$start_polling()
