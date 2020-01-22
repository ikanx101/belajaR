# lift puzzle
rm(list=ls())
setwd("/cloud/project/Bukan Infografis/puzzles")

# bikin fungsi
monte1 = function(){
  push = sample(c(1:13),3,replace=T)
  push = sort(push)
  beda = diff(push) == 1
  hot = ifelse(beda[1]==T & beda[2]==T,1,0)
  return(hot)
}

# instead looping, kita pake replicate
# mengoptimalkan R vector
data = data.frame(n = c(1:9000),
                  prob = 0)

for(i in 1:9000){
  hasil = replicate(i,monte1())
  data$prob[i] = sum(hasil)/i
}
tail(data)
data %>% ggplot(aes(x=n,y=prob)) + geom_line(group=1)

i=500

# puzzle umur