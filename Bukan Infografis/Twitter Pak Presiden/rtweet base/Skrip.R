rm(list=ls())
setwd('D:/Project_R/Kamis Data/Twitter')

key ='pFEbMsK2gPDUN2S3PjB5jUA48'
secret='LWiC89vjVX2nEMAP83sHPHRPBj58KhIo1pz4ZLr4vO5s0Gp4pZ'
token='920366929-BdLIIPPKr9iqd9jyiP6ACjgvDBQG0rMj1RppAFuc'
token_se='I5LCsS5N0ekUmow4QHnRQXJQF5PgaGU6zrb91ZxucyhBD'
app='ikanx_r'

# create token named "twitter_token" 
library(rtweet)
twitter_token <- create_token( app = app, consumer_key = key, consumer_secret = secret, access_token = token, access_secret = token_se)


# uji coba yah
rt = search_tweets(
  "#coronavirus", n = 100, include_rts = FALSE,token=get_token()
)

# namanya sapa
nama = rt %>% group_by(screen_name) %>% summarise(banyak = n()) %>% arrange(desc(banyak)) 
  
# cari follower
i=1
tes = get_friends(nama$screen_name[i])
hasil = lookup_users(tes$user_id)
new = data.frame(word1 = as.character(nama$screen_name[i]),word2 = as.character(hasil$screen_name),n=1)

bigram_igraph = new %>% graph_from_data_frame()

a <- grid::arrow(type = "closed", length = unit(.05, "inches"))
set.seed(7)
ggraph(bigram_igraph, layout = "nicely") +
  geom_edge_link(aes(edge_alpha = n), show.legend = FALSE,
                 arrow = a, end_cap = circle(.07, 'inches')) +
  geom_node_point(color = "lightblue", size = 1) +
  theme_graph()


rt = get_timeline('lokalate',n=3000)
