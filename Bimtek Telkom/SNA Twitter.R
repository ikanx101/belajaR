rm(list=ls())

rt <- stream_tweets("medan")
src = rt$screen_name
target = unlist(rt$mentions_screen_name) #belum selesai

library(networkD3)
networkData <- data.frame(src, target)
simpleNetwork(networkData, nodeColour = "red", zoom=T, height=300, width=300,fontSize = 16)
