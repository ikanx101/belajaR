#EXERCISE USING THE SNA PACKAGE
setwd("/cloud/project/Bukan Infografis/Social Network Analysis")

data = read.table('http://vlado.fmf.uni-lj.si/pub/networks/data/Ucinet/zachary.dat',header=F, skip=7)
B = as.matrix(data)

#kita pakai edge list baru kita bisa pakai igraph graph_from_data_frame
#coba pakai data workplace yah






#ini ambil dari tel-u
people <- c("dandi", "lala", "reza", "ais", "eci")
people

B <- matrix(
  c(0,1,0,0,1,
    0,0,0,1,1,
    1,1,0,0,1,
    0,1,0,0,1,
    0,1,1,0,0),
  nrow=5,
  ncol=5, dimnames = list(people,people))
B

library(sna)

gplot (B, displaylabels=TRUE)

od <-degree(B, cmode = 'outdegree')
gplot (B, displaylabels=TRUE, vertex.cex = od )

id <-degree(B, cmode = 'indegree')
gplot (B, displaylabels=TRUE, vertex.cex = id )

fr <-degree(B, cmode = 'freeman')
gplot (B, displaylabels=TRUE, vertex.cex = fr)

#closeness
closeness(B)

#betweeness
betweenness(B)

#density
network(B)
B <- network(B)
network.density(B)