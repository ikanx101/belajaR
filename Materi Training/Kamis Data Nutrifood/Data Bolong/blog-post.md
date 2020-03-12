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
    ## 3     3      el-Sylla             2
    ## 4     4          <NA>             2
    ## 5     5          <NA>             2
    ## 6     6          <NA>             2
    ## 7     7          <NA>             2
    ## 8     8          <NA>             2
    ## 9     9        Rucker             3
    ## 10   10          <NA>             3
    ## 11   11          <NA>             3
    ## 12   12          <NA>             3
    ## 13   13          <NA>             3
    ## 14   14          <NA>             3
    ## 15   15          <NA>             3
    ## 16   16          <NA>             3
    ## 17   17          <NA>             3
    ## 18   18        Ashley             4
    ## 19   19      el-Salah             5
    ## 20   20       Villani             6
    ## 21   21     Levengood             7
    ## 22   22          <NA>             7
    ## 23   23          <NA>             7
    ## 24   24          <NA>             7
    ## 25   25          <NA>             7
    ## 26   26          <NA>             7
    ## 27   27          <NA>             7
    ## 28   28          <NA>             7
    ## 29   29          <NA>             7
    ## 30   30          <NA>             7
    ## 31   31          <NA>             7
    ## 32   32          <NA>             7
    ## 33   33          <NA>             7
    ## 34   34          <NA>             7
    ## 35   35          <NA>             7
    ## 36   36          <NA>             7
    ## 37   37          <NA>             7
    ## 38   38          <NA>             7
    ## 39   39          <NA>             7
    ## 40   40          <NA>             7
    ## 41   41          <NA>             7
    ## 42   42          <NA>             7
    ## 43   43          <NA>             7
    ## 44   44          <NA>             7
    ## 45   45          <NA>             7
    ## 46   46       Runnels             8
    ## 47   47          <NA>             8
    ## 48   48          <NA>             8
    ## 49   49          <NA>             8
    ## 50   50          <NA>             8
    ## 51   51          <NA>             8
    ## 52   52         Sirio             9
    ## 53   53          <NA>             9
    ## 54   54          <NA>             9
    ## 55   55          <NA>             9
    ## 56   56          <NA>             9
    ## 57   57          <NA>             9
    ## 58   58          <NA>             9
    ## 59   59          <NA>             9
    ## 60   60          <NA>             9
    ## 61   61          Hill            10
    ## 62   62          <NA>            10
    ## 63   63          <NA>            10
    ## 64   64          <NA>            10
    ## 65   65         Trejo            11
    ## 66   66          <NA>            11
    ## 67   67          <NA>            11
    ## 68   68          <NA>            11
    ## 69   69          <NA>            11
    ## 70   70          <NA>            11
    ## 71   71          <NA>            11
    ## 72   72          <NA>            11
    ## 73   73          <NA>            11
    ## 74   74          <NA>            11
    ## 75   75          <NA>            11
    ## 76   76          <NA>            11
    ## 77   77          <NA>            11
    ## 78   78          <NA>            11
    ## 79   79          <NA>            11
    ## 80   80          <NA>            11
    ## 81   81          <NA>            11
    ## 82   82          <NA>            11
    ## 83   83          <NA>            11
    ## 84   84          <NA>            11
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
