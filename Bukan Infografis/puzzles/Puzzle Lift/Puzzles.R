# lift puzzle
rm(list=ls())
setwd("/cloud/project/Bukan Infografis/puzzles/Puzzle Lift")

# bikin fungsi
monte1 = function(){
  push = sample(c(1:15),3,replace=T)
  push = sort(push)
  beda = diff(push) == 1
  hot = ifelse(beda[1]==T & beda[2]==T,1,0)
  return(hot)
}

prob_hit = function(n){
  hasil = replicate(n,monte1())
  prob = sum(hasil)/n
  return(prob)
}

# instead looping, kita pake replicate
# mengoptimalkan R vector
data = data.frame(n = c(1:100))

data$prob = sapply(data$n,prob_hit)

tail(data)
data %>% ggplot(aes(x=n,y=prob)) + geom_line(group=1)
