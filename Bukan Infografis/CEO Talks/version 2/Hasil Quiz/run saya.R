rm(list=ls())
library(dplyr)
library(NLP)
library(tm)
library(e1071)
library(gmodels)
library(ggplot2)

# ambil model
setwd("~/Documents/belajaR/Bukan Infografis/CEO Talks/version 2")
load("model version 2.rda")

# ambil jawaban
setwd("~/Documents/belajaR/Bukan Infografis/CEO Talks/version 2/Hasil Quiz")
data = read.csv("CEO's Partner.csv")

# agility
text = data$Tulis.5.kata.yang.terkait.dengan.AGILE..Cukup.pisahkan.dengan.spasi
coba = VCorpus(VectorSource(text))
sms_corpus_clean.coba = tm_map(coba, content_transformer(tolower))
sms_corpus_clean.coba = tm_map(sms_corpus_clean.coba, removeNumbers)
sms_corpus_clean.coba = tm_map(sms_corpus_clean.coba, removePunctuation)
sms_corpus_clean.coba = tm_map(sms_corpus_clean.coba, stripWhitespace)
sms_dtm.coba = DocumentTermMatrix(sms_corpus_clean.coba)
sms_freq_terms.coba <- findFreqTerms(sms_dtm.coba, 1)
sms_data_freq_coba <- sms_dtm.coba[ , sms_freq_terms.coba]
sms_coba <- apply(sms_data_freq_coba, MARGIN = 2, convert_counts)
hasil = predict(sms_classifier_train2, sms_coba,type = "raw")
final = data.frame(
  nama = paste(data$Nama,data$Departemen,sep = "-"),
  agility_score = hasil[,1]
)

# digital trans
text = data$Tulis.5.kata.yang.terkait.dengan.DIGITAL.TRANSFORMATION..Cukup.pisahkan.dengan.spasi
coba = VCorpus(VectorSource(text))
sms_corpus_clean.coba = tm_map(coba, content_transformer(tolower))
sms_corpus_clean.coba = tm_map(sms_corpus_clean.coba, removeNumbers)
sms_corpus_clean.coba = tm_map(sms_corpus_clean.coba, removePunctuation)
sms_corpus_clean.coba = tm_map(sms_corpus_clean.coba, stripWhitespace)
sms_dtm.coba = DocumentTermMatrix(sms_corpus_clean.coba)
sms_freq_terms.coba <- findFreqTerms(sms_dtm.coba, 1)
sms_data_freq_coba <- sms_dtm.coba[ , sms_freq_terms.coba]
sms_coba <- apply(sms_data_freq_coba, MARGIN = 2, convert_counts)
hasil = predict(sms_classifier_train2, sms_coba,type = "raw")
final$digtrans_score = hasil[,2]

# inclusive
text = data$Tulis.5.kata.yang.terkait.dengan.INCLUSIVE..Cukup.pisahkan.dengan.spasi
coba = VCorpus(VectorSource(text))
sms_corpus_clean.coba = tm_map(coba, content_transformer(tolower))
sms_corpus_clean.coba = tm_map(sms_corpus_clean.coba, removeNumbers)
sms_corpus_clean.coba = tm_map(sms_corpus_clean.coba, removePunctuation)
sms_corpus_clean.coba = tm_map(sms_corpus_clean.coba, stripWhitespace)
sms_dtm.coba = DocumentTermMatrix(sms_corpus_clean.coba)
sms_freq_terms.coba <- findFreqTerms(sms_dtm.coba, 1)
sms_data_freq_coba <- sms_dtm.coba[ , sms_freq_terms.coba]
sms_coba <- apply(sms_data_freq_coba, MARGIN = 2, convert_counts)
hasil = predict(sms_classifier_train2, sms_coba,type = "raw")
final$inclusive_score = hasil[,3]

# purposeful
text = data$Tulis.5.kata.yang.terkait.dengan.PURPOSEFUL..Cukup.pisahkan.dengan.spasi
coba = VCorpus(VectorSource(text))
sms_corpus_clean.coba = tm_map(coba, content_transformer(tolower))
sms_corpus_clean.coba = tm_map(sms_corpus_clean.coba, removeNumbers)
sms_corpus_clean.coba = tm_map(sms_corpus_clean.coba, removePunctuation)
sms_corpus_clean.coba = tm_map(sms_corpus_clean.coba, stripWhitespace)
sms_dtm.coba = DocumentTermMatrix(sms_corpus_clean.coba)
sms_freq_terms.coba <- findFreqTerms(sms_dtm.coba, 1)
sms_data_freq_coba <- sms_dtm.coba[ , sms_freq_terms.coba]
sms_coba <- apply(sms_data_freq_coba, MARGIN = 2, convert_counts)
hasil = predict(sms_classifier_train2, sms_coba,type = "raw")
final$purposeful_score = hasil[,4]

final = 
  final %>% 
  mutate(score = (agility_score + digtrans_score + inclusive_score + purposeful_score)/4)

library("RColorBrewer")

for_wc = 
  final %>% 
  select(nama,score) %>% 
  rename(word = nama,
         freq = score) %>% 
  mutate(freq = round(freq*100,0)) %>% 
  mutate(freq = as.integer(freq)) %>% 
  arrange(desc(freq)) %>% 
  head(40)
png("Leaderboard cloud.png",width = 1500,height = 1050)
#dev.new(width = 1000, height = 1000, unit = "px")
wordcloud::wordcloud(words = for_wc$word, 
                     freq = for_wc$freq, 
                     min.freq = 0,
                     max.words=100, 
                     random.order=FALSE,
                     rot.per = .25,
                     colors=brewer.pal(5, "Dark2"))
dev.off()

plot = 
  for_wc %>% 
  mutate(nama = word,
         score = freq) %>% 
  ggplot(aes(x = reorder(nama,score),
             y = score)) +
  geom_col(aes(fill = score),color = "black") +
  scale_fill_gradient(low = "darkred",high = "darkgreen") +
  coord_flip() +
  labs(title = "Leaderboard: TOP 40 Highest Score",
       subtitle = "NCODE 2020 Games",
       caption = paste("created using R",print(Sys.time()),sep = "\n")) +
  theme_minimal() +
  theme(axis.title = element_blank(),
        axis.text.x = element_blank(),
        legend.position = "none")
ggsave(plot,filename = "hasil.png",dpi = 400,width = 6,height = 8)
