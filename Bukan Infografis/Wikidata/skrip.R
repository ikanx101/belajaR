library(WikidataR)
rm(list=ls())

a <- find_item("Interstellar")
b <- Reduce(rbind,lapply(a, function(x) cbind(x$title,x$label)))
data = data.frame(b)

new = get_item(id = "Q13417189")
get_property(id = "Q3318231")
