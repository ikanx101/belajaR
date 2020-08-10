library(RWordPress)
# Set login parameters (replace admin,password and blog_url!)
options(WordpressLogin = c(fakeikanx = 'suntea101'), WordpressURL = 'https://passingthroughresearcher.wordpress.com/xmlrpc.php')

opts_knit$set(upload.fun = function(file){library(RWordPress);uploadFile(file)$url;})

library(knitr)
postid <- knit2wp('t test.Rmd', title = 'Ingat Kembali Uji Hipotesis', categories=c('R'),mt_keywords = c('Data Science',
                                                                                                         'Machine Learning',
                                                                                                         'Artificial Intelligence',
                                                                                                         'R',
                                                                                                         'T Test',
                                                                                                         'Parametrik',
                                                                                                         'Non Parametrik'),
                  publish=FALSE)