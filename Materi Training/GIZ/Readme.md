Bahan Training R - GIZ
================

# Selamat datang di R

## *Objects* di R

Ada beberapa *objects* atau struktur data di R, yakni:

1.  Single variabel
2.  Vector atau array
3.  Tibble atau Data frame
4.  List

## Tipe data

Ada beberapa tipe data di data science, yakni:

1.  Character
2.  Numerik
3.  Integer (atau bisa berupa factor)
4.  Logical (TRUE / FALSE)

# Yuk kita mulai materinya

# Selamat datang di R

## Single variabel

``` r
a = 10
b <- 3
a+b
```

    ## [1] 13

``` r
c=a*b^2/100
kalimat='saya suka pergi ke pasar' #jika variabelnya berupa text
kalimat_baru = "i don't like pizza"
```

## Vector atau array

``` r
tes_vector=c(1,3,6,5,4,7)
id=c(1:10) #contoh generating sequence
a=seq(1,10,0.5) #contoh generating sequence by 0.5
sample(c(100:200),5,replace=F) #generating random number
```

    ## [1] 141 188 113 118 172

``` r
kalimat = 'saya biasa pergi ke kantor setiap jam 7 pagi'
pecah.kata=strsplit(kalimat,' ') #pecah kalimat menjadi kata dan mengubahnya menjadi array

# Yang penting di array
length(a)
```

    ## [1] 19

``` r
a[2]
```

    ## [1] 1.5

``` r
summary(a)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    1.00    3.25    5.50    5.50    7.75   10.00

``` r
# Operasi aritmatika pada array
a+3
```

    ##  [1]  4.0  4.5  5.0  5.5  6.0  6.5  7.0  7.5  8.0  8.5  9.0  9.5 10.0 10.5
    ## [15] 11.0 11.5 12.0 12.5 13.0

``` r
a*6
```

    ##  [1]  6  9 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60

## Logic atau boolean

``` r
#boolean expression
1==2
```

    ## [1] FALSE

``` r
ifelse(1+2==3,'anda benar','anda salah')
```

    ## [1] "anda benar"

``` r
ifelse(1+2!=3,'anda benar','anda salah')
```

    ## [1] "anda salah"

``` r
ifelse(1+2<=3,'anda benar','anda salah')
```

    ## [1] "anda benar"

``` r
ifelse(1+2>=3,'anda benar','anda salah')
```

    ## [1] "anda benar"

``` r
ifelse(1+2<3,'anda benar','anda salah')
```

    ## [1] "anda salah"

``` r
ifelse(1+2>3,'anda benar','anda salah')
```

    ## [1] "anda salah"

### Another useful function

#### Paste

``` r
nomor=c(1:100)
nama.toko=paste('toko',nomor,sep='_')
nama.toko
```

    ##   [1] "toko_1"   "toko_2"   "toko_3"   "toko_4"   "toko_5"   "toko_6"  
    ##   [7] "toko_7"   "toko_8"   "toko_9"   "toko_10"  "toko_11"  "toko_12" 
    ##  [13] "toko_13"  "toko_14"  "toko_15"  "toko_16"  "toko_17"  "toko_18" 
    ##  [19] "toko_19"  "toko_20"  "toko_21"  "toko_22"  "toko_23"  "toko_24" 
    ##  [25] "toko_25"  "toko_26"  "toko_27"  "toko_28"  "toko_29"  "toko_30" 
    ##  [31] "toko_31"  "toko_32"  "toko_33"  "toko_34"  "toko_35"  "toko_36" 
    ##  [37] "toko_37"  "toko_38"  "toko_39"  "toko_40"  "toko_41"  "toko_42" 
    ##  [43] "toko_43"  "toko_44"  "toko_45"  "toko_46"  "toko_47"  "toko_48" 
    ##  [49] "toko_49"  "toko_50"  "toko_51"  "toko_52"  "toko_53"  "toko_54" 
    ##  [55] "toko_55"  "toko_56"  "toko_57"  "toko_58"  "toko_59"  "toko_60" 
    ##  [61] "toko_61"  "toko_62"  "toko_63"  "toko_64"  "toko_65"  "toko_66" 
    ##  [67] "toko_67"  "toko_68"  "toko_69"  "toko_70"  "toko_71"  "toko_72" 
    ##  [73] "toko_73"  "toko_74"  "toko_75"  "toko_76"  "toko_77"  "toko_78" 
    ##  [79] "toko_79"  "toko_80"  "toko_81"  "toko_82"  "toko_83"  "toko_84" 
    ##  [85] "toko_85"  "toko_86"  "toko_87"  "toko_88"  "toko_89"  "toko_90" 
    ##  [91] "toko_91"  "toko_92"  "toko_93"  "toko_94"  "toko_95"  "toko_96" 
    ##  [97] "toko_97"  "toko_98"  "toko_99"  "toko_100"

#### Print

``` r
nomor=c(1:100)
print(nomor)
```

    ##   [1]   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17
    ##  [18]  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34
    ##  [35]  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51
    ##  [52]  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68
    ##  [69]  69  70  71  72  73  74  75  76  77  78  79  80  81  82  83  84  85
    ##  [86]  86  87  88  89  90  91  92  93  94  95  96  97  98  99 100

## Tibble atau Data Frame

Struktur data tibble atau data frame sejatinya mirip dengan data
tradisional di **MS. EXCEL**.

### Sebelum masuk ke data frame:

``` r
# Misalkan kita buat dua variabel sbb:
suhu=sample(100,50,replace=T)
cacat=sample(10,50,replace=T)

# Membuat histogram dari suhu
hist(suhu)
```

![](Readme_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

``` r
# Membuat histogram dari suhu
hist(cacat)
```

![](Readme_files/figure-gfm/unnamed-chunk-6-2.png)<!-- -->

``` r
# Uji Korelasi
cor.test(suhu,cacat)
```

    ## 
    ##  Pearson's product-moment correlation
    ## 
    ## data:  suhu and cacat
    ## t = 0.95624, df = 48, p-value = 0.3437
    ## alternative hypothesis: true correlation is not equal to 0
    ## 95 percent confidence interval:
    ##  -0.1472252  0.3998558
    ## sample estimates:
    ##       cor 
    ## 0.1367255

``` r
# Hanya menampilkan angka korelasi saja
cor(suhu,cacat)
```

    ## [1] 0.1367255

``` r
# Simple plot suhu vs cacat
plot(suhu,cacat)
```

![](Readme_files/figure-gfm/unnamed-chunk-6-3.png)<!-- -->

### Membangun data frame dari kumpulan vector

Data frame bisa dibangun dari dua atau lebih vector yang memiliki
`length` sama.

``` r
#membuat data frame
data=data.frame(suhu,cacat)
data
```

    ##    suhu cacat
    ## 1    33    10
    ## 2    33     4
    ## 3    48     7
    ## 4    36     9
    ## 5    26     2
    ## 6    56     8
    ## 7    58    10
    ## 8    54     7
    ## 9    53     3
    ## 10   30     8
    ## 11   13     2
    ## 12   92     8
    ## 13   50     2
    ## 14   11     1
    ## 15   70    10
    ## 16   88     8
    ## 17   48     8
    ## 18    4     8
    ## 19   54     7
    ## 20   37     1
    ## 21   85     5
    ## 22   20     2
    ## 23   62     8
    ## 24   54     8
    ## 25   33     3
    ## 26   36     6
    ## 27   18     9
    ## 28  100     3
    ## 29   19     8
    ## 30   30     9
    ## 31   49     5
    ## 32   64     9
    ## 33   59     2
    ## 34   58     4
    ## 35   14     9
    ## 36   81     7
    ## 37   27     6
    ## 38   10     6
    ## 39   83    10
    ## 40   68    10
    ## 41   81     8
    ## 42   43    10
    ## 43   17    10
    ## 44   66     5
    ## 45   25     6
    ## 46   21     1
    ## 47   57     8
    ## 48   41    10
    ## 49   77     1
    ## 50   15     4

### Another useful function di data frame

Untuk melihat data frame bisa menggunakan fungsi `View(data)`.

``` r
str(data)
```

    ## 'data.frame':    50 obs. of  2 variables:
    ##  $ suhu : int  33 33 48 36 26 56 58 54 53 30 ...
    ##  $ cacat: int  10 4 7 9 2 8 10 7 3 8 ...

``` r
summary(data)
```

    ##       suhu            cacat      
    ##  Min.   :  4.00   Min.   : 1.00  
    ##  1st Qu.: 26.25   1st Qu.: 4.00  
    ##  Median : 48.00   Median : 7.00  
    ##  Mean   : 46.14   Mean   : 6.30  
    ##  3rd Qu.: 61.25   3rd Qu.: 8.75  
    ##  Max.   :100.00   Max.   :10.00

``` r
length(data)
```

    ## [1] 2

``` r
head(data,5) #menampilkan data 5 teratas
```

    ##   suhu cacat
    ## 1   33    10
    ## 2   33     4
    ## 3   48     7
    ## 4   36     9
    ## 5   26     2

``` r
tail(data,5) #menampilkan data 5 terbawah
```

    ##    suhu cacat
    ## 46   21     1
    ## 47   57     8
    ## 48   41    10
    ## 49   77     1
    ## 50   15     4

``` r
data[1]
```

    ##    suhu
    ## 1    33
    ## 2    33
    ## 3    48
    ## 4    36
    ## 5    26
    ## 6    56
    ## 7    58
    ## 8    54
    ## 9    53
    ## 10   30
    ## 11   13
    ## 12   92
    ## 13   50
    ## 14   11
    ## 15   70
    ## 16   88
    ## 17   48
    ## 18    4
    ## 19   54
    ## 20   37
    ## 21   85
    ## 22   20
    ## 23   62
    ## 24   54
    ## 25   33
    ## 26   36
    ## 27   18
    ## 28  100
    ## 29   19
    ## 30   30
    ## 31   49
    ## 32   64
    ## 33   59
    ## 34   58
    ## 35   14
    ## 36   81
    ## 37   27
    ## 38   10
    ## 39   83
    ## 40   68
    ## 41   81
    ## 42   43
    ## 43   17
    ## 44   66
    ## 45   25
    ## 46   21
    ## 47   57
    ## 48   41
    ## 49   77
    ## 50   15

``` r
data[,1]
```

    ##  [1]  33  33  48  36  26  56  58  54  53  30  13  92  50  11  70  88  48
    ## [18]   4  54  37  85  20  62  54  33  36  18 100  19  30  49  64  59  58
    ## [35]  14  81  27  10  83  68  81  43  17  66  25  21  57  41  77  15

``` r
data[2]
```

    ##    cacat
    ## 1     10
    ## 2      4
    ## 3      7
    ## 4      9
    ## 5      2
    ## 6      8
    ## 7     10
    ## 8      7
    ## 9      3
    ## 10     8
    ## 11     2
    ## 12     8
    ## 13     2
    ## 14     1
    ## 15    10
    ## 16     8
    ## 17     8
    ## 18     8
    ## 19     7
    ## 20     1
    ## 21     5
    ## 22     2
    ## 23     8
    ## 24     8
    ## 25     3
    ## 26     6
    ## 27     9
    ## 28     3
    ## 29     8
    ## 30     9
    ## 31     5
    ## 32     9
    ## 33     2
    ## 34     4
    ## 35     9
    ## 36     7
    ## 37     6
    ## 38     6
    ## 39    10
    ## 40    10
    ## 41     8
    ## 42    10
    ## 43    10
    ## 44     5
    ## 45     6
    ## 46     1
    ## 47     8
    ## 48    10
    ## 49     1
    ## 50     4

``` r
data[,2]
```

    ##  [1] 10  4  7  9  2  8 10  7  3  8  2  8  2  1 10  8  8  8  7  1  5  2  8
    ## [24]  8  3  6  9  3  8  9  5  9  2  4  9  7  6  6 10 10  8 10 10  5  6  1
    ## [47]  8 10  1  4

``` r
data[1,1] #melihat data di posisi row,column
```

    ## [1] 33

``` r
data[1,2] #melihat data di posisi row,column
```

    ## [1] 10

``` r
data[1,1]=NA #menghapus data di posisi row,column
```

### Bermain dengan element dan tanda `$`

``` r
data$suhu
```

    ##  [1]  NA  33  48  36  26  56  58  54  53  30  13  92  50  11  70  88  48
    ## [18]   4  54  37  85  20  62  54  33  36  18 100  19  30  49  64  59  58
    ## [35]  14  81  27  10  83  68  81  43  17  66  25  21  57  41  77  15

``` r
data$cacat
```

    ##  [1] 10  4  7  9  2  8 10  7  3  8  2  8  2  1 10  8  8  8  7  1  5  2  8
    ## [24]  8  3  6  9  3  8  9  5  9  2  4  9  7  6  6 10 10  8 10 10  5  6  1
    ## [47]  8 10  1  4

``` r
data.baru=data[-1]
data.baru
```

    ##    cacat
    ## 1     10
    ## 2      4
    ## 3      7
    ## 4      9
    ## 5      2
    ## 6      8
    ## 7     10
    ## 8      7
    ## 9      3
    ## 10     8
    ## 11     2
    ## 12     8
    ## 13     2
    ## 14     1
    ## 15    10
    ## 16     8
    ## 17     8
    ## 18     8
    ## 19     7
    ## 20     1
    ## 21     5
    ## 22     2
    ## 23     8
    ## 24     8
    ## 25     3
    ## 26     6
    ## 27     9
    ## 28     3
    ## 29     8
    ## 30     9
    ## 31     5
    ## 32     9
    ## 33     2
    ## 34     4
    ## 35     9
    ## 36     7
    ## 37     6
    ## 38     6
    ## 39    10
    ## 40    10
    ## 41     8
    ## 42    10
    ## 43    10
    ## 44     5
    ## 45     6
    ## 46     1
    ## 47     8
    ## 48    10
    ## 49     1
    ## 50     4

### Another useful function di data frame (part 2)

``` r
is.na(data) #melihat ada yang kosong
```

    ##        suhu cacat
    ##  [1,]  TRUE FALSE
    ##  [2,] FALSE FALSE
    ##  [3,] FALSE FALSE
    ##  [4,] FALSE FALSE
    ##  [5,] FALSE FALSE
    ##  [6,] FALSE FALSE
    ##  [7,] FALSE FALSE
    ##  [8,] FALSE FALSE
    ##  [9,] FALSE FALSE
    ## [10,] FALSE FALSE
    ## [11,] FALSE FALSE
    ## [12,] FALSE FALSE
    ## [13,] FALSE FALSE
    ## [14,] FALSE FALSE
    ## [15,] FALSE FALSE
    ## [16,] FALSE FALSE
    ## [17,] FALSE FALSE
    ## [18,] FALSE FALSE
    ## [19,] FALSE FALSE
    ## [20,] FALSE FALSE
    ## [21,] FALSE FALSE
    ## [22,] FALSE FALSE
    ## [23,] FALSE FALSE
    ## [24,] FALSE FALSE
    ## [25,] FALSE FALSE
    ## [26,] FALSE FALSE
    ## [27,] FALSE FALSE
    ## [28,] FALSE FALSE
    ## [29,] FALSE FALSE
    ## [30,] FALSE FALSE
    ## [31,] FALSE FALSE
    ## [32,] FALSE FALSE
    ## [33,] FALSE FALSE
    ## [34,] FALSE FALSE
    ## [35,] FALSE FALSE
    ## [36,] FALSE FALSE
    ## [37,] FALSE FALSE
    ## [38,] FALSE FALSE
    ## [39,] FALSE FALSE
    ## [40,] FALSE FALSE
    ## [41,] FALSE FALSE
    ## [42,] FALSE FALSE
    ## [43,] FALSE FALSE
    ## [44,] FALSE FALSE
    ## [45,] FALSE FALSE
    ## [46,] FALSE FALSE
    ## [47,] FALSE FALSE
    ## [48,] FALSE FALSE
    ## [49,] FALSE FALSE
    ## [50,] FALSE FALSE

``` r
!is.na(data) #melihat pasti terisi
```

    ##        suhu cacat
    ##  [1,] FALSE  TRUE
    ##  [2,]  TRUE  TRUE
    ##  [3,]  TRUE  TRUE
    ##  [4,]  TRUE  TRUE
    ##  [5,]  TRUE  TRUE
    ##  [6,]  TRUE  TRUE
    ##  [7,]  TRUE  TRUE
    ##  [8,]  TRUE  TRUE
    ##  [9,]  TRUE  TRUE
    ## [10,]  TRUE  TRUE
    ## [11,]  TRUE  TRUE
    ## [12,]  TRUE  TRUE
    ## [13,]  TRUE  TRUE
    ## [14,]  TRUE  TRUE
    ## [15,]  TRUE  TRUE
    ## [16,]  TRUE  TRUE
    ## [17,]  TRUE  TRUE
    ## [18,]  TRUE  TRUE
    ## [19,]  TRUE  TRUE
    ## [20,]  TRUE  TRUE
    ## [21,]  TRUE  TRUE
    ## [22,]  TRUE  TRUE
    ## [23,]  TRUE  TRUE
    ## [24,]  TRUE  TRUE
    ## [25,]  TRUE  TRUE
    ## [26,]  TRUE  TRUE
    ## [27,]  TRUE  TRUE
    ## [28,]  TRUE  TRUE
    ## [29,]  TRUE  TRUE
    ## [30,]  TRUE  TRUE
    ## [31,]  TRUE  TRUE
    ## [32,]  TRUE  TRUE
    ## [33,]  TRUE  TRUE
    ## [34,]  TRUE  TRUE
    ## [35,]  TRUE  TRUE
    ## [36,]  TRUE  TRUE
    ## [37,]  TRUE  TRUE
    ## [38,]  TRUE  TRUE
    ## [39,]  TRUE  TRUE
    ## [40,]  TRUE  TRUE
    ## [41,]  TRUE  TRUE
    ## [42,]  TRUE  TRUE
    ## [43,]  TRUE  TRUE
    ## [44,]  TRUE  TRUE
    ## [45,]  TRUE  TRUE
    ## [46,]  TRUE  TRUE
    ## [47,]  TRUE  TRUE
    ## [48,]  TRUE  TRUE
    ## [49,]  TRUE  TRUE
    ## [50,]  TRUE  TRUE

``` r
data.baru <- data[complete.cases(data), ] #jika mau menghapus baris2 yang ada NA nya! 

data$suhu=ifelse(data$suhu<50,NA,data$suhu) #menghapus data suhu yang aneh (di bawah 50'C)
cor(data.baru$suhu,data.baru$cacat) #hitung korelasi baru
```

    ## [1] 0.1533993

### Sorting data frame

Seringkali pekerjaan kita di data frame banyak melibatkan *sort* data.
Bagaimana melakukannya di **R**?

#### Cara 1

Menggunakan **base R**.

``` r
#sorting data
sorted.data=data.baru[order(data.baru$suhu),] #descending
sorted.data=data.baru[order(-data.baru$suhu),] #ascending
```

#### Cara 2

Menggunakan `library(tidyverse)` ATAU minimal dengan `library(dplyr)`

``` r
library(tidyverse)
data.baru %>% arrange(suhu)
```

    ##    suhu cacat
    ## 1     4     8
    ## 2    10     6
    ## 3    11     1
    ## 4    13     2
    ## 5    14     9
    ## 6    15     4
    ## 7    17    10
    ## 8    18     9
    ## 9    19     8
    ## 10   20     2
    ## 11   21     1
    ## 12   25     6
    ## 13   26     2
    ## 14   27     6
    ## 15   30     8
    ## 16   30     9
    ## 17   33     4
    ## 18   33     3
    ## 19   36     9
    ## 20   36     6
    ## 21   37     1
    ## 22   41    10
    ## 23   43    10
    ## 24   48     7
    ## 25   48     8
    ## 26   49     5
    ## 27   50     2
    ## 28   53     3
    ## 29   54     7
    ## 30   54     7
    ## 31   54     8
    ## 32   56     8
    ## 33   57     8
    ## 34   58    10
    ## 35   58     4
    ## 36   59     2
    ## 37   62     8
    ## 38   64     9
    ## 39   66     5
    ## 40   68    10
    ## 41   70    10
    ## 42   77     1
    ## 43   81     7
    ## 44   81     8
    ## 45   83    10
    ## 46   85     5
    ## 47   88     8
    ## 48   92     8
    ## 49  100     3

``` r
data.baru %>% arrange(desc(cacat))
```

    ##    suhu cacat
    ## 1    58    10
    ## 2    70    10
    ## 3    83    10
    ## 4    68    10
    ## 5    43    10
    ## 6    17    10
    ## 7    41    10
    ## 8    36     9
    ## 9    18     9
    ## 10   30     9
    ## 11   64     9
    ## 12   14     9
    ## 13   56     8
    ## 14   30     8
    ## 15   92     8
    ## 16   88     8
    ## 17   48     8
    ## 18    4     8
    ## 19   62     8
    ## 20   54     8
    ## 21   19     8
    ## 22   81     8
    ## 23   57     8
    ## 24   48     7
    ## 25   54     7
    ## 26   54     7
    ## 27   81     7
    ## 28   36     6
    ## 29   27     6
    ## 30   10     6
    ## 31   25     6
    ## 32   85     5
    ## 33   49     5
    ## 34   66     5
    ## 35   33     4
    ## 36   58     4
    ## 37   15     4
    ## 38   53     3
    ## 39   33     3
    ## 40  100     3
    ## 41   26     2
    ## 42   13     2
    ## 43   50     2
    ## 44   20     2
    ## 45   59     2
    ## 46   11     1
    ## 47   37     1
    ## 48   21     1
    ## 49   77     1

### Menghapus global environment

``` r
rm(list=ls()) #digunakan untuk membersihkan global data environment
```

### Set working directory

`setwd('/cloud/project/Materi Training/GIZ')`

# Kita mulai bagian serunya yah\!\!\!

## Membuat model *price elasticity*

Secara logika, semakin tinggi harga suatu barang, semakin sedikit orang
yang akan membelinya. Secara simpel kita bisa bilang bahwa `harga`
berkorelasi negatif dengan sales `qty`. Tapi untuk mengatakan ada
kausalitas antara `harga`dan sales `qty`, kita harus cek dulu model
regresinya.

Selain itu, kita ingin menghitung suatu nilai *fixed* (kita sebut saja
suatu *price elasticity index*). Dimana jika `harga` naik sebesar **a
%** maka sales `qty` akan turun sebesar **index %**\_.

Contoh yah, misalkan saya punya data jualan harian suatu barang beserta
harganya di suatu minimarket sebagai berikut:

``` r
library(dplyr)
data = read.csv('/cloud/project/Materi Training/GIZ/latihan regresi.csv') %>% 
  mutate(X = NULL)
str(data)
```

    ## 'data.frame':    60 obs. of  3 variables:
    ##  $ id   : int  1 4 5 6 9 15 19 27 30 32 ...
    ##  $ harga: num  18.4 17.3 21 19 15.8 17.5 17.7 15.3 17.1 21.1 ...
    ##  $ qty  : num  9.05 9.5 6.16 8.64 8.91 ...

``` r
summary(data)
```

    ##        id             harga            qty        
    ##  Min.   :  1.00   Min.   :15.00   Min.   : 5.632  
    ##  1st Qu.: 40.50   1st Qu.:16.88   1st Qu.: 7.277  
    ##  Median : 74.50   Median :18.85   Median : 8.159  
    ##  Mean   : 77.12   Mean   :18.76   Mean   : 8.013  
    ##  3rd Qu.:118.75   3rd Qu.:20.55   3rd Qu.: 8.804  
    ##  Max.   :148.00   Max.   :22.00   Max.   :10.626

``` r
head(data,10)
```

    ##    id harga     qty
    ## 1   1  18.4  9.0534
    ## 2   4  17.3  9.4958
    ## 3   5  21.0  6.1620
    ## 4   6  19.0  8.6400
    ## 5   9  15.8  8.9076
    ## 6  15  17.5  8.0800
    ## 7  19  17.7  8.3040
    ## 8  27  15.3 10.1024
    ## 9  30  17.1  9.2708
    ## 10 32  21.1  6.3516

Berapa sih nilai kodelasi antara `harga` dan `qty`?

``` r
korel = cor(data$harga,data$qty)
korel
```

    ## [1] -0.8323464

Ternyata angka korelasinya kuat negatif. Artinya, jika kita membuat
model regresi linear dari kedua data ini, maka akan didapat
**R-Squared** sebesar kuadrat nilai korelasinya. *Nah*, sekarang kita
coba buat model regresinya *yuk*.

``` r
model_reg = lm(qty~harga,data = data)
summary(model_reg)
```

    ## 
    ## Call:
    ## lm(formula = qty ~ harga, data = data)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -1.1620 -0.5572  0.1328  0.5908  0.9959 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  17.1082     0.7998   21.39   <2e-16 ***
    ## harga        -0.4849     0.0424  -11.44   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.6545 on 58 degrees of freedom
    ## Multiple R-squared:  0.6928, Adjusted R-squared:  0.6875 
    ## F-statistic: 130.8 on 1 and 58 DF,  p-value: < 2.2e-16

## Evaluasi model

Sekarang kita lihat *goodness of fit* dari model regresi di atas. Untuk
mengevaluasi apakah suatu model regresi baik, kita bisa lihat dari
beberapa hal seperti:

1.  **R-squared**
2.  **P-value**
3.  MAE ( *mean absolut error* )
4.  Lainnya

### R squared

Nilainya bisa diambil dari nilai **multiple R-squared** pada model atau
bisa juga dihitung menggunakan:

``` r
r_squared = modelr::rsquare(model_reg,data)
r_squared
```

    ## [1] 0.6928005

Mari kita cek apakah nilai **R-Squared** sama dengan korelasi yang
dikuadratkan yah. Ini sengaja saya *round* biar memudahkan yah.

``` r
round(r_squared,5) == round(korel^2,5)
```

    ## [1] TRUE

**R-squared** bisa diartikan sebagai berapa persen variabel X meng-
*explain* variabel Y.

### P-value

Nilai **P-value** didapatkan dari `summary(model_reg)`, yakni mendekati
nol (sangat kecil). Oleh karena `p-value < 0.05` bisa diambil kesimpulan
bahwa model `harga` berpengaruh terhadap sales `qty`.

### MAE

*Mean absolut error* dapat diartikan sebagai rata-rata nilai mutlak
*error* yang dapat kita terima. Tidak ada angka pasti harus berapa, tapi
semakin kecil *error*, berarti semakin baik model kita.

Menurut pengetahuan saya, **MAE** digunakan jika kita memiliki lebih
dari satu model regresi yang ingin dibandingkan mana yang terbaik.

``` r
mean_absolut_error = modelr::mae(model_reg,data) 
mean_absolut_error
```

    ## [1] 0.563642

### Kesimpulan

Berhubung dari **P-value** dan **R-squared** menghasilkan nilai yang
baik, dapat disimpulkan bahwa `harga` mempengaruhi dan mengakibatkan
perubahan pada sales `qty` secara negatif.

### Cara lain

Sebenarnya ada cara lain untuk melakukan analisa regresi linear
menggunakan **R**, yakni dengan memanfaatkan *library* `ggplot2` dan
`ggpubr`.

``` r
library(ggplot2)
library(ggpubr)
```

    ## Loading required package: magrittr

    ## 
    ## Attaching package: 'magrittr'

    ## The following object is masked from 'package:purrr':
    ## 
    ##     set_names

    ## The following object is masked from 'package:tidyr':
    ## 
    ##     extract

``` r
data %>% ggplot(aes(x=harga,y=qty)) + 
  geom_point() + 
  geom_smooth(method='lm') +
  theme_pubclean() + 
  stat_regline_equation(label.y = 7,aes(label =  paste(..eq.label.., ..rr.label.., sep = "~~~~"))) +
  labs(title = 'Model Regresi: Price Elasticity Index',
                          subtitle = 'Data harga vs sales qty',
                          caption = 'Created using R',
                          x = 'Harga produk (dalam ribu rupiah)',
                          y = 'Sales Qty') +
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(size=25,face='bold.italic'),
        plot.caption = element_text(size=10,face='italic'))
```

![](Readme_files/figure-gfm/unnamed-chunk-20-1.png)<!-- -->

## Optimization dari model regresi

Kita telah mendapatkan model regresi linear yang baik. Kita juga sudah
menghitung *price elasticty index*. Pertanyaan selanjutnya adalah:
*Apakah kita bisa menghitung harga terbaik untuk produk tersebut?*

Mari kita definisikan terlebih dahulu, apa itu harga terbaik? Harga
terbaik adalah harga yang membuat kita mendapatkan omset paling
maksimal.

Bagaimana menghitung omset?

Omset didefinisikan sebagai: `omset = harga*qty`

Coba kita ingat kembali, kita telah memiliki formula regresi:
`qty=m*harga + c`

Jika kita substitusi persamaan `qty` ke persamaan `omset`, maka kita
akan dapatkan:

`omset = harga*(m*harga + c)`

`omset = m*harga^2 + c*harga`

Berhubung nilai `m` adalah negatif, maka saya bisa tuliskan persamaan
finalnya menjadi:

`omset = -m*harga^2 + c*harga`

*Oke*, mari kita ingat kuliah kalkulus I dulu. Jika kita punya persamaan
kuadrat dengan konstanta depan negatif, apa artinya?

### Inget Kalkulus I\!

Sebagai *reminder*, coba yah kalau saya buat grafik dari persamaan `y =
x^2` seperti di bawah ini:

``` r
x = c(-10:10)
y = x^2
contoh = data.frame(x,y)
contoh %>% ggplot(aes(x,y)) + geom_line()
```

![](Readme_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

Jika kita punya persamaan kuadrat positif semacam ini, akan selalu ada
nilai `x` yang memberikan `y` minimum.

Sekarang jika saya memiliki persamaan kuadrat `y = - x^2`, bentuk
grafiknya sebagai berikut:

``` r
x = c(-10:10)
y = -x^2
contoh = data.frame(x,y)
contoh %>% ggplot(aes(x,y)) + geom_line()
```

![](Readme_files/figure-gfm/unnamed-chunk-22-1.png)<!-- -->

Jadi, jika kita memiliki persamaan kuadrat dengan konstanta negatif,
maka akan selalu ada nilai `x` yang memberikan `y` maksimum\!

### Balik lagi ke regresi kita

Nah, berhubung kita punya formula regresi berupa persamaan kuadrat, maka
dipastikan akan selalu ada `harga` yang memberikan `omset` maksimum.

Sekarang mari kita lakukan simulasi untuk mendapatkan `harga` paling
optimal.

``` r
harga_baru = seq(5,50,.5)
data_simulasi = data.frame(harga = harga_baru)
qty_baru = predict(model_reg,
                   newdata = data_simulasi)
omset = harga_baru * qty_baru
hasil = data.frame(omset,harga_baru,qty_baru)
hasil %>% 
  ggplot(aes(x=harga_baru,y=omset)) +
  geom_line()
```

![](Readme_files/figure-gfm/unnamed-chunk-23-1.png)<!-- -->

Secara grafis dapat dilihat bahwa sebenarnya ada satu titik `harga_baru`
yang memberikan `omset` paling tinggi. Yakni pada harga:

``` r
hasil %>% 
  filter(omset == max(omset)) %>%
  select(harga_baru)
```

    ##   harga_baru
    ## 1       17.5

*So*, harga optimal sudah kita dapatkan.

*Any question?*
