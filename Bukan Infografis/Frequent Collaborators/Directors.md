Frequent Collaborators In Movies
================

Percaya atau tidak, dalam bekerja biasanya kita memilih rekan kerja yang
memang kita nyaman bekerja dengannya. Sama saat para sutradara terbaik
dunia dalam membuat film, ternyata ada beberapa aktor atau aktris yang
menjadi **langganan** mereka untuk bekerja sama.

Terinspirasi dari [**Six Degree of Kevin
Bacon**](https://en.m.wikipedia.org/wiki/Six_Degrees_of_Kevin_Bacon),
saya iseng akan membuat aktor atau aktris siapa yang memiliki koneksi
kerjasama banyak dengan sutradara-sutradara tersebut.

Datanya akan saya scrap dari informasi detail yang tersedia di
**Wikipedia** yah.

Contohnya, pada film [Spider-Man: Far From
Home](https://en.wikipedia.org/wiki/Spider-Man:_Far_From_Home), data
hasil *scrap*-nya seperti ini:

    ##                        judul sutradara            aktors
    ## 1  Spider-Man: Far From Home Jon Watts       Tom Holland
    ## 2  Spider-Man: Far From Home Jon Watts Samuel L. Jackson
    ## 3  Spider-Man: Far From Home Jon Watts           Zendaya
    ## 4  Spider-Man: Far From Home Jon Watts    Cobie Smulders
    ## 5  Spider-Man: Far From Home Jon Watts       Jon Favreau
    ## 6  Spider-Man: Far From Home Jon Watts      J. B. Smoove
    ## 7  Spider-Man: Far From Home Jon Watts     Jacob Batalon
    ## 8  Spider-Man: Far From Home Jon Watts      Martin Starr
    ## 9  Spider-Man: Far From Home Jon Watts      Marisa Tomei
    ## 10 Spider-Man: Far From Home Jon Watts   Jake Gyllenhaal

Nah, kita akan *scrap* data 10 film dengan *highest grossing* dari tahun
2000 - 2019. Kita dapatkan data sebagai berikut:

``` r
urls = c('https://en.wikipedia.org/wiki/Avengers:_Endgame',
         'https://en.wikipedia.org/wiki/The_Lion_King_(2019_film)',
         'https://en.wikipedia.org/wiki/Frozen_II',
         'https://en.wikipedia.org/wiki/Captain_Marvel_(film)',
         'https://en.wikipedia.org/wiki/Toy_Story_4',
         'https://en.wikipedia.org/wiki/Joker_(2019_film)',
         'https://en.wikipedia.org/wiki/Aladdin_(2019_film)',
         'https://en.wikipedia.org/wiki/Star_Wars:_The_Rise_of_Skywalker',
         'https://en.wikipedia.org/wiki/Hobbs_%26_Shaw',
         'https://en.wikipedia.org/wiki/Avengers:_Infinity_War',
         'https://en.wikipedia.org/wiki/Black_Panther_(film)',
         'https://en.wikipedia.org/wiki/Jurassic_World:_Fallen_Kingdom',
         'https://en.wikipedia.org/wiki/Incredibles_2',
         'https://en.wikipedia.org/wiki/Aquaman_(film)',
         'https://en.wikipedia.org/wiki/Bohemian_Rhapsody_(film)',
         'https://en.wikipedia.org/wiki/Venom_(2018_film)',
         'https://en.wikipedia.org/wiki/Mission:_Impossible_%E2%80%93_Fallout',
         'https://en.wikipedia.org/wiki/Deadpool_2',
         'https://en.wikipedia.org/wiki/Fantastic_Beasts:_The_Crimes_of_Grindelwald')

for(i in 1:length(urls)){
  temp = scrap(urls[i])
  data = rbind(data,temp)
}

str(data)
```

    ## 'data.frame':    185 obs. of  3 variables:
    ##  $ judul    : Factor w/ 20 levels "Spider-Man: Far From Home",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ sutradara: Factor w/ 18 levels "Jon Watts","Anthony RussoJoe Russo",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ aktors   : Factor w/ 164 levels "Cobie Smulders",..: 9 8 10 1 5 2 3 7 6 4 ...
