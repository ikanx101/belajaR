rm(list=ls())
library(telegram.bot)
library(telegram)
library(readxl)
library(rvest)
updater <- Updater(token = bot_token("RTelegramBot"))
bot <- TGBot$new(token = bot_token('RTelegramBot'))

# Get bot info
print(bot$getMe())

# Get updates
update <- bot$getUpdates()

start <- function(bot, update){
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = paste('Hai Kak ',update$message$from$first_name,', perkenalkan saya i.k.a.n.x_bot_ver_1.5\nSilakan tanyakan tentang machine learning, artificial intelligence, atau apapun itu ya... #projectiseng\nContoh: Apa itu machine learning?\nCari tahu harga emas saat ini, ketik /emas',sep=''))
}

start_handler <- CommandHandler('start', start)
updater <- updater + start_handler

cari <- function(bot, update){
  url='https://harga-emas.org/1-gram/'
  txt = read_html(url) %>% html_nodes('td') %>% html_text()
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = paste('Pada ',txt[13],', per 1 gram emas harganya Rp',txt[11],sep=''))
}
start_handler <- CommandHandler('emas', cari)
updater <- updater + start_handler

cari <- function(bot, update){
  url='https://harga-emas.org/1-gram/'
  txt = read_html(url) %>% html_nodes('td') %>% html_text()
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = paste('Pada ',txt[13],', per 1 USD nilai tukarnya adalah Rp',txt[8],sep=''))
}
start_handler <- CommandHandler('rupiah', cari)
updater <- updater + start_handler

##########################
#Trial detik.com
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

start_handler <- function(bot, update){
  text <- "Saya masih belum belajar itu... Maklum #projectiseng, mau bantu develop bot ini? hehehe.\nTry: `Apa itu machine learning?`\n Try: `Apa itu algoritma?`\natau ketik: /start /emas /rupiah /detik\n\n\natau silakan berkunjung ke blog saya di: https://passingthroughresearcher.wordpress.com/"
  if (grepl('mean',tolong.donk(update$message$text),ignore.case = T)){text = "Salah satu ukuran pemusatan data. Biasa disebut dengan rata - rata. Dihitung dengan membagi jumlah data dengan banyaknya data. Contoh kasus: https://passingthroughresearcher.wordpress.com/2019/01/01/market-research-101-analisa-punya-point-of-view-lhoo/"}
  else if (grepl('belajar',tolong.donk(update$message$text),ignore.case = T)){text = "Ada berbagai macam cara untuk belajar machine learning. Bisa ambil online course atau hands on dan melihat forum tanya jawab seperti stackoverflow. Tapi pertanyaan yang lebih mendasar adalah `kapan saya harus mulai belajar machine learning?`. Silakan membaca tulisan lengkap saya di: https://passingthroughresearcher.wordpress.com/2018/12/18/kapan-saya-harus-belajar-machine-learning"}
  else if (grepl('median',tolong.donk(update$message$text),ignore.case = T)){text = "Salah satu ukuran pemusatan data. Biasa disebut dengan nilai tengah. Dicari dengan mengurutkan data dari terkecil ke terbesar lalu lihat di mana tengahnya. Contoh kasus: https://passingthroughresearcher.wordpress.com/2019/01/01/market-research-101-analisa-punya-point-of-view-lhoo/"}
  else if (grepl('modus',tolong.donk(update$message$text),ignore.case = T)){text = "Salah satu ukuran pemusatan data. Dicari dengan cara melihat data yang paling sering muncul. Biasanya kita sering mendengarkan modus dalam kata: `mayoritas`. Contoh kasus: https://passingthroughresearcher.wordpress.com/2019/01/01/market-research-101-analisa-punya-point-of-view-lhoo/"}
  else if (grepl('machine',tolong.donk(update$message$text),ignore.case = T)){text = "Secara definisi, machine learning adalah: method of data analysis that automates analytical model building. Kalau saya pribadi lebih senang menyebutnya computational science and statistics. Jadi kalau ada komputasi yang rumit dan melelahkan bagi manusia, biar mesin saja yang melakukannya.\n\nBisa buat apa aja sih?\nMacem-macem yah, dari mulai analisa data (structured atau unstructured) sampai webscrapping data.\n\nSilakan berkunjung ke blog saya di: https://passingthroughresearcher.wordpress.com/ \n\nTry: Bagaimana cara belajarnya?"}
  else if (grepl('ml',tolong.donk(update$message$text),ignore.case = T)){text = "Secara definisi, machine learning adalah: method of data analysis that automates analytical model building. Kalau saya pribadi lebih senang menyebutnya computational science and statistics. Jadi kalau ada komputasi yang rumit dan melelahkan bagi manusia, biar mesin saja yang melakukannya. \n\nBisa buat apa aja sih?\nMacem-macem yah, dari mulai analisa data (structured atau unstructured) sampai webscrapping data.\n\nSilakan berkunjung ke blog saya di: https://passingthroughresearcher.wordpress.com/ \n\nTry: Bagaimana cara belajarnya?"}
  else if (grepl('artificial',tolong.donk(update$message$text),ignore.case = T)){text = "Secara definisi, artificial intelligence adalah kecerdasan buatan. Terms ini pertama muncul pada tahun 1950-an. Merupakan umbrella terms dari berbagai related fields yang digunakan untuk memecahkan masalah komputasi seperti matematika, statistik, dan engineering. Pada dasarnya artificial intelligence saat ini adalah kumpulan algoritma yang ditulis oleh manusia untuk mengerjakan well-defined-tasks (paling sering digunakan untuk repetitive tasks). Istilah machine learning dan deep learning termasuk ke dalam AI itu sendiri. Seringkali orang mempersepsikan AI sebagai suatu hal yang sangat luar biasa (bisa melakukan banyak hal secara sendiri), namun demikian tidak seperti itu.Ada dua tools / bahasa yang sering digunakan, yakni R dan Pyton. Mau tau lebih lanjut? Ketik:\nR atau\nPyton"}
  else if (grepl('algoritma',tolong.donk(update$message$text),ignore.case = T)){text = "Secara simpel algoritma berarti proses berpikir. Bisa dituliskan sebagai baris perintah atau workflow. Sekarang ini kata algoritma erat diasosiasikan sebagai kumpulan baris perintah yang kemudian akan dijalankan oleh mesin atau robot."}
  else if (tolong.donk(update$message$text) == "r"){text = "R atau GNU R adalah software open source yang digunakan dalam computational science. Biasa digunakan oleh matematikawan dan statistikawan untuk melakukan data analisis. Tidak cuma itu, R juga bisa digunakan untuk melakukan pekerjaan lain seperti web scrapping, video analyzing, image data processing, geolocation analysis, bikin chatbot (seperti bot ini) dll. Silakan masuk ke blog saya di https://passingthroughresearcher.wordpress.com/ untuk contoh kasus yang digunakan dengan R."}
  else if (tolong.donk(update$message$text) == "pyton"){text = "Pyton pada awalnya digunakan developer untuk membuat software atau aplikasi. Namun sekarang ini digunakan untuk membuat algoritma dan analisa data. Banyak perdebatan mengenai siapa yang terbaik antara R dan Pyton. Tapi saya rasa keduanya memiliki pangsa pasar dan tujuan masing-masing."}
  else if (grepl('kasih',tolong.donk(update$message$text),ignore.case = T)){text = "Terima kasih kembali... n_n"}
  else if (grepl('trims',tolong.donk(update$message$text),ignore.case = T)){text = "Terima kasih kembali... n_n"}
  else if (grepl('thx',tolong.donk(update$message$text),ignore.case = T)){text = "Terima kasih kembali... n_n"}
  else if (grepl('thank',tolong.donk(update$message$text),ignore.case = T)){text = "Terima kasih kembali... n_n"}
  else if (grepl('thanx',tolong.donk(update$message$text),ignore.case = T)){text = "Terima kasih kembali... n_n"}
  else if (tolong.donk(update$message$text) == "sample"|tolong.donk(update$message$text) == "sampel"){text = "Tentang sample, apa yang mau Anda ketahui?\nDefinisi sampel\nCara menghitung banyaknya sampel\nTeknik sampling"}
  else if (tolong.donk(update$message$text) == "hi"|tolong.donk(update$message$text) == "hai"|tolong.donk(update$message$text) == "halo"){text = "hai, ada yang bisa dibantu kah?\nCoba tuliskan: mean"}
  else if (tolong.donk(update$message$text) == "hii"|tolong.donk(update$message$text) == "test"|tolong.donk(update$message$text) == "tes"){text = "hai, ada yang bisa dibantu kah?\nCoba tuliskan: artificial intelligence"}
  else if (tolong.donk(update$message$text) == "hallo"|tolong.donk(update$message$text) == "haloo"|tolong.donk(update$message$text) == "helo"){text = "hai, ada yang bisa dibantu kah?\nCoba tuliskan: sample"}
  else if (tolong.donk(update$message$text) == "ya"|tolong.donk(update$message$text) == "hellow"|tolong.donk(update$message$text) == "kang"){text = "hai, ada yang bisa dibantu kah?\nCoba tuliskan: modus"}
  else if (tolong.donk(update$message$text) == "ikang"){text = "hai, ada yang bisa dibantu kah?\nCoba tuliskan: median"}
  else if (grepl('salam',tolong.donk(update$message$text),ignore.case = T)){text = "Wa alaikum Salam"}
  else if (tolong.donk(update$message$text) == "assw"){text = "Wa alaikum Salam"}
  else if (tolong.donk(update$message$text) == "asw"){text = "Wa alaikum Salam"}
  else if (tolong.donk(update$message$text) == "ass"){text = "Wa alaikum Salam"}
  else if (tolong.donk(update$message$text) == "pa"){text = "Kenapa San?"}
  else if (tolong.donk(update$message$text) == "kamu siapa"){text = "Saya chatbot versi #projectiseng ya... Semoga semakin lama bisa semakin pintar. Aamiin..."}
  else if (tolong.donk(update$message$text) == "kamu apa"){text = "Saya chatbot versi #projectiseng ya... Semoga semakin lama bisa semakin pintar. Aamiin..."}
  else if (tolong.donk(update$message$text) == "km siapa"){text = "Saya chatbot versi #projectiseng ya... Semoga semakin lama bisa semakin pintar. Aamiin..."}
  else if (tolong.donk(update$message$text) == "km apa"){text = "Saya chatbot versi #projectiseng ya... Semoga semakin lama bisa semakin pintar. Aamiin..."}
  else if (tolong.donk(update$message$text) == "siapa kamu"){text = "Saya chatbot versi #projectiseng ya... Semoga semakin lama bisa semakin pintar. Aamiin..."}
  else if (tolong.donk(update$message$text) == "siapa km"){text = "Saya chatbot versi #projectiseng ya... Semoga semakin lama bisa semakin pintar. Aamiin..."}
  else if (tolong.donk(update$message$text) == "apa kamu"){text = "Saya chatbot versi #projectiseng ya... Semoga semakin lama bisa semakin pintar. Aamiin..."}
  else if (tolong.donk(update$message$text) == "apa km"){text = "Saya chatbot versi #projectiseng ya... Semoga semakin lama bisa semakin pintar. Aamiin..."}
  else if (tolong.donk(update$message$text) == "oh gtu ya"){text = "Iya Kak... Kakak mau tanya apa? yang gampang-gampang aja ya Kak..."}
  else if (tolong.donk(update$message$text) == "oh gitu ya"){text = "Iya Kak... Kakak mau tanya apa? yang gampang-gampang aja ya Kak..."}
  else if (tolong.donk(update$message$text) == "oh gt ya"){text = "Iya Kak... Kakak mau tanya apa? yang gampang-gampang aja ya Kak..."}
  else if (tolong.donk(update$message$text) == "oh gt y"){text = "Iya Kak... Kakak mau tanya apa? yang gampang-gampang aja ya Kak..."}
  bot$sendMessage(chat_id = update$message$chat_id, text = text)
}

updater <- updater + MessageHandler(start_handler, MessageFilters$text)
print('Versi 1.5')
updater$start_polling()
