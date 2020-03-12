Data Carpentry: Filling in NA’s data
================

# Data Carpentry

Salah satu kegunaan **R** yang paling saya rasakan adalah kita bisa
membuat algoritma otomasi dalam melakukan *data cleaning*.

Pada [tulisan yang
lalu](https://ikanx101.github.io/blog/data-carpentry-carmudi/), saya
sudah mencontohkan bagaimana membuat algoritma yang bisa melakukan *web
scraping* sekaligus membersihkannya agar siap dianalisa.

Sekarang saya ingin mencontohkan proses *data cleaning* yang terlihat
sepele tapi bisa jadi *painful* saat dilakukan secara manual dan
berulang-ulang.

## Apa itu?

Mengisi data bolong\!

-----

# Contoh Kasus I

Suatu waktu saya berhadapan dengan data **Excel** seperti berikut ini:

    ##      id nama_karyawan urutan_ceklis
    ## 1     1         Ikang             1
    ## 2     2          <NA>             1
    ## 3     3          <NA>             1
    ## 4     4          <NA>             1
    ## 5     5          <NA>             1
    ## 6     6          <NA>             1
    ## 7     7          <NA>             1
    ## 8     8          <NA>             1
    ## 9     9          <NA>             1
    ## 10   10          <NA>             1
    ## 11   11          <NA>             1
    ## 12   12        Lucero             2
    ## 13   13          <NA>             2
    ## 14   14          <NA>             2
    ## 15   15          <NA>             2
    ## 16   16          <NA>             2
    ## 17   17          <NA>             2
    ## 18   18          <NA>             2
    ## 19   19          <NA>             2
    ## 20   20          <NA>             2
    ## 21   21           Lee             3
    ## 22   22          <NA>             3
    ## 23   23          <NA>             3
    ## 24   24          <NA>             3
    ## 25   25     Styerwalt             4
    ## 26   26          <NA>             4
    ## 27   27          <NA>             4
    ## 28   28          <NA>             4
    ## 29   29         Simon             5
    ## 30   30          <NA>             5
    ## 31   31          <NA>             5
    ## 32   32          <NA>             5
    ## 33   33           Lao             6
    ## 34   34          <NA>             6
    ## 35   35          <NA>             6
    ## 36   36          <NA>             6
    ## 37   37          <NA>             6
    ## 38   38          <NA>             6
    ## 39   39          <NA>             6
    ## 40   40          <NA>             6
    ## 41   41          <NA>             6
    ## 42   42          <NA>             6
    ## 43   43        el-Gad             7
    ## 44   44          <NA>             7
    ## 45   45          <NA>             7
    ## 46   46          <NA>             7
    ## 47   47          <NA>             7
    ## 48   48          <NA>             7
    ## 49   49       Hoffman             8
    ## 50   50          <NA>             8
    ## 51   51          <NA>             8
    ## 52   52          <NA>             8
    ## 53   53          <NA>             8
    ## 54   54          <NA>             8
    ## 55   55          <NA>             8
    ## 56   56     al-Younes             9
    ## 57   57          <NA>             9
    ## 58   58          <NA>             9
    ## 59   59          <NA>             9
    ## 60   60          <NA>             9
    ## 61   61          <NA>             9
    ## 62   62          <NA>             9
    ## 63   63          <NA>             9
    ## 64   64          <NA>             9
    ## 65   65          <NA>             9
    ## 66   66          <NA>             9
    ## 67   67          <NA>             9
    ## 68   68          <NA>             9
    ## 69   69          <NA>             9
    ## 70   70          <NA>             9
    ## 71   71          <NA>             9
    ## 72   72          <NA>             9
    ## 73   73          <NA>             9
    ## 74   74          <NA>             9
    ## 75   75          <NA>             9
    ## 76   76          <NA>             9
    ## 77   77          <NA>             9
    ## 78   78          <NA>             9
    ## 79   79          <NA>             9
    ## 80   80          <NA>             9
    ## 81   81       Ramirez            10
    ## 82   82          <NA>            10
    ## 83   83          <NA>            10
    ## 84   84         Smith            11
    ## 85   85          <NA>            11
    ## 86   86          <NA>            11
    ## 87   87          <NA>            11
    ## 88   88          <NA>            11
    ## 89   89          <NA>            11
    ## 90   90          <NA>            11
    ## 91   91          <NA>            11
    ## 92   92          <NA>            11
    ## 93   93          <NA>            11
    ## 94   94          <NA>            11
    ## 95   95          <NA>            11
    ## 96   96          <NA>            11
    ## 97   97          <NA>            11
    ## 98   98          <NA>            11
    ## 99   99          <NA>            11
    ## 100 100          <NA>            11

Saya harus mengisi data pada variabel `nama_karyawan` yang kosong dengan
isi atasnya. Hal ini sepertinya sepele, tapi jika variabel yang harus
diisi ada banyak dan baris datanya juga banyak, saya jamin akan lumayan
mengerjakannya.

Oleh karena itu, saya akan contohkan algoritma pengerjaannya di **R**.

Cara pengerjaannya sebenarnya simpel, yakni dengan menggunakan
*conditional* dan
*looping*.

<img src="https://raw.githubusercontent.com/ikanx101/belajaR/master/Materi%20Training/Kamis%20Data%20Nutrifood/Data%20Bolong/algoritma.png" width="80%" />

*Conditional* tersebut akan diulang ke semua baris data.

``` r
for(i in 2:100){
  data$nama_karyawan[i] = ifelse(is.na(data$nama_karyawan[i]),
                                 data$nama_karyawan[i-1],
                                 data$nama_karyawan[i])
}
data
```

    ##      id nama_karyawan urutan_ceklis
    ## 1     1         Ikang             1
    ## 2     2         Ikang             1
    ## 3     3         Ikang             1
    ## 4     4         Ikang             1
    ## 5     5         Ikang             1
    ## 6     6         Ikang             1
    ## 7     7         Ikang             1
    ## 8     8         Ikang             1
    ## 9     9         Ikang             1
    ## 10   10         Ikang             1
    ## 11   11         Ikang             1
    ## 12   12        Lucero             2
    ## 13   13        Lucero             2
    ## 14   14        Lucero             2
    ## 15   15        Lucero             2
    ## 16   16        Lucero             2
    ## 17   17        Lucero             2
    ## 18   18        Lucero             2
    ## 19   19        Lucero             2
    ## 20   20        Lucero             2
    ## 21   21           Lee             3
    ## 22   22           Lee             3
    ## 23   23           Lee             3
    ## 24   24           Lee             3
    ## 25   25     Styerwalt             4
    ## 26   26     Styerwalt             4
    ## 27   27     Styerwalt             4
    ## 28   28     Styerwalt             4
    ## 29   29         Simon             5
    ## 30   30         Simon             5
    ## 31   31         Simon             5
    ## 32   32         Simon             5
    ## 33   33           Lao             6
    ## 34   34           Lao             6
    ## 35   35           Lao             6
    ## 36   36           Lao             6
    ## 37   37           Lao             6
    ## 38   38           Lao             6
    ## 39   39           Lao             6
    ## 40   40           Lao             6
    ## 41   41           Lao             6
    ## 42   42           Lao             6
    ## 43   43        el-Gad             7
    ## 44   44        el-Gad             7
    ## 45   45        el-Gad             7
    ## 46   46        el-Gad             7
    ## 47   47        el-Gad             7
    ## 48   48        el-Gad             7
    ## 49   49       Hoffman             8
    ## 50   50       Hoffman             8
    ## 51   51       Hoffman             8
    ## 52   52       Hoffman             8
    ## 53   53       Hoffman             8
    ## 54   54       Hoffman             8
    ## 55   55       Hoffman             8
    ## 56   56     al-Younes             9
    ## 57   57     al-Younes             9
    ## 58   58     al-Younes             9
    ## 59   59     al-Younes             9
    ## 60   60     al-Younes             9
    ## 61   61     al-Younes             9
    ## 62   62     al-Younes             9
    ## 63   63     al-Younes             9
    ## 64   64     al-Younes             9
    ## 65   65     al-Younes             9
    ## 66   66     al-Younes             9
    ## 67   67     al-Younes             9
    ## 68   68     al-Younes             9
    ## 69   69     al-Younes             9
    ## 70   70     al-Younes             9
    ## 71   71     al-Younes             9
    ## 72   72     al-Younes             9
    ## 73   73     al-Younes             9
    ## 74   74     al-Younes             9
    ## 75   75     al-Younes             9
    ## 76   76     al-Younes             9
    ## 77   77     al-Younes             9
    ## 78   78     al-Younes             9
    ## 79   79     al-Younes             9
    ## 80   80     al-Younes             9
    ## 81   81       Ramirez            10
    ## 82   82       Ramirez            10
    ## 83   83       Ramirez            10
    ## 84   84         Smith            11
    ## 85   85         Smith            11
    ## 86   86         Smith            11
    ## 87   87         Smith            11
    ## 88   88         Smith            11
    ## 89   89         Smith            11
    ## 90   90         Smith            11
    ## 91   91         Smith            11
    ## 92   92         Smith            11
    ## 93   93         Smith            11
    ## 94   94         Smith            11
    ## 95   95         Smith            11
    ## 96   96         Smith            11
    ## 97   97         Smith            11
    ## 98   98         Smith            11
    ## 99   99         Smith            11
    ## 100 100         Smith            11
