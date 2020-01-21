Frequent Collaborators In Movies
================

Percaya atau tidak, dalam bekerja biasanya kita memilih rekan kerja yang
memang kita nyaman bekerja dengannya. Hal ini berlaku untuk semua bidang
pekerjaan.

Sama saat para sutradara terbaik dunia dalam membuat film, ternyata ada
beberapa aktor atau aktris yang menjadi **langganan** mereka untuk
bekerja sama.

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

    ## 'data.frame':    1553 obs. of  3 variables:
    ##  $ judul    : chr  "Spider-Man: Far From Home" "Spider-Man: Far From Home" "Spider-Man: Far From Home" "Spider-Man: Far From Home" ...
    ##  $ sutradara: chr  "Jon Watts" "Jon Watts" "Jon Watts" "Jon Watts" ...
    ##  $ aktors   : chr  "Tom Holland" "Samuel L. Jackson" "Zendaya" "Cobie Smulders" ...

Berapa banyak film yang saya dapatkan?

    ## [1] 200

![](Directors_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->
