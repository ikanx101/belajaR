Frequent Collaborators with Special Directors
================

Percaya atau tidak, dalam bekerja biasanya kita memilih rekan kerja yang
memang kita nyaman bekerja dengannya. Sama saat para sutradara terbaik
dunia dalam membuat film, ternyata ada beberapa aktor atau aktris yang
menjadi **langganan** mereka untuk bekerja sama.

Terinspirasi dari [**Six Degree of Kevin
Bacon**](https://en.m.wikipedia.org/wiki/Six_Degrees_of_Kevin_Bacon),
saya iseng akan membuat aktor atau aktris siapa yang memiliki koneksi
kerjasama banyak dengan sutradara-sutradara tersebut.

Datanya akan saya scrap dari *frequent collaborators list* yang ada di
situs **imdb**. *List* tersebut dibuat oleh para *user*-nya yang
budiman.

Oh iya, definisi sutradara terbaik berdasarkan hasil *googling* saya
pribadi *yah*. Jadi kalau ada sutradara favorit kalian *gak* masuk,
*plis jangan baper*.

``` r
library(rvest)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggpubr)

# frequent collaborator

sutradara = c('Christopher Nolan',
             'Steven Spielberg',
             'Quentin Tarantino',
             'Martin Scorcese',
             'James Cameron',
             'Tim Burton',
             'Woody Allen',
             'Guillermo del Toro',
             'David Fincher')
link = c('https://www.imdb.com/list/ls025424824/',
         'https://www.imdb.com/list/ls025576884/',
         'https://www.imdb.com/list/ls062132042/',
         'https://www.imdb.com/list/ls069712546/',
         'https://www.imdb.com/list/ls025557041/',
         'https://www.imdb.com/list/ls025557713/',
         'https://www.imdb.com/list/ls062798057/',
         'https://www.imdb.com/list/ls027677705/',
         'https://www.imdb.com/list/ls025555822/')

scrap = function(director,urls){
  data = 
    read_html(urls) %>% {
    tibble(
      nama = director,
      collab = html_nodes(.,'.lister-item-header a') %>% html_text()
    )
  }
  return(data)
}

data_1 = scrap(sutradara[1],link[1])

for(i in 2:length(sutradara)){
  temp = scrap(sutradara[i],link[i])
  data_1 = rbind(data_1,temp)
}

data_1
```

    ## # A tibble: 161 x 2
    ##    nama              collab                   
    ##    <chr>             <chr>                    
    ##  1 Christopher Nolan " Michael Caine\n"       
    ##  2 Christopher Nolan " Christian Bale\n"      
    ##  3 Christopher Nolan " Mark Boone Junior\n"   
    ##  4 Christopher Nolan " Tom Hardy\n"           
    ##  5 Christopher Nolan " Joseph Gordon-Levitt\n"
    ##  6 Christopher Nolan " Cillian Murphy\n"      
    ##  7 Christopher Nolan " Marion Cotillard\n"    
    ##  8 Christopher Nolan " Liam Neeson\n"         
    ##  9 Christopher Nolan " Gary Oldman\n"         
    ## 10 Christopher Nolan " Morgan Freeman\n"      
    ## # … with 151 more rows
