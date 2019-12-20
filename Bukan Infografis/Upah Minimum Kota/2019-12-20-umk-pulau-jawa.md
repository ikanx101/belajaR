Upah Minimum Kota di Pulau Jawa
================

    ## Loading required package: xml2

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    ## Loading required package: magrittr

    ## 
    ## Attaching package: 'tidyr'

    ## The following object is masked from 'package:magrittr':
    ## 
    ##     extract

Sebagai seorang orang yang berkecimpung di dunia *recruitment* dan *HR*,
nyonya malam ini mengajak diskusi terkait dengan data hasil survey
mengenai **Indonesia Salary Benchmark** yang dilakukan oleh lembaga
bernama *Michael Page*.

> *Seharusnya gaji kamu itu segini lho…* Katanya sambil menunjuk ke
> hasil surveynya.

> *Oh begitu yah?* Jawab saya sambil tersenyum.

Persoalan mengenai gaji memang tiada habisnya. Dari level yang tinggi
sampai yang paling bawah. Terlebih lagi saat kita membahas masalah
**Upah Minimum Provinsi atau Kota** yang ada di Pulau Jawa.
Masing-masing provinsi dan kota memiliki cara perhitungan masing-masing
sehingga besarannya juga berbeda.

Ada yang masih menjadi polemik, ada yang tenang-tenang saja dan minim
pemberitaan.

Penasaran dengan besaran UMK tersebut, saya coba *Googling* sana-sini
untuk mendapatkan datanya.

> *Kalau nemu dalam bentuk tabel, enak banget nih scrap-nya* Pikir saya.

Tapi setelah mencari-cari kok tidak ketemu yah.

Akhirnya saya putuskan untuk mengambil datanya dari teks di [halaman
berita
ini](https://www.kompas.com/tren/read/2019/11/22/191520565/disahkan-berikut-rincian-ump-dan-umk-2020-di-dki-jakarta-jawa-barat-jawa?page=all).

## Scrap data

Saya mulai dengan scrap data menggunakan `library(rvest)` di **R**. Tapi
sayang sekali, formatnya masih *unstructured* sebagai berikut:

    ##  [1] "Kabupaten Karawang Rp 4.594.324"     
    ##  [2] "Kota Bekasi Rp 4.589.708"            
    ##  [3] "Kabupaten Bekasi Rp. 4.498.961"      
    ##  [4] "Kota Depok Rp 4.202.105"             
    ##  [5] "Kota Bogor Rp 4.169.806"             
    ##  [6] "Kabupaten Bogor Rp 4.083.670"        
    ##  [7] "Kabupaten Purwakarta Rp 4.039.067"   
    ##  [8] "Kota Bandung Rp 3.623.778"           
    ##  [9] "Kabupaten Bandung Barat Rp 3.145.427"
    ## [10] "Kabupaten Sumedang Rp 3.139.275"     
    ## [11] "Kabupaten Bandung Rp 3.139.275"      
    ## [12] "Kota Cimahi Rp 3.139.274"            
    ## [13] "Kabupaten Sukabumi Rp 3.028.531"     
    ## [14] "Kabupaten Subang Rp 2.965.468"       
    ## [15] "Kabupaten Cianjur Rp 2.534.798"

## Data carpentry

Bentuk data itu harus saya ubah dulu agar bisa dianalisa lebih lanjut.
Sebenarnya caranya simpel yah, jika diperhatikan baik - baik, saya bisa
melakukan `separate` dengan memanfaatkan pola adanya tanda **Rp** di
setiap baris data.

Setelah itu, saya akan tambahkan informasi mengenai nama provinsi
sebagai variabel. Sehingga didapatkan data sebagai berikut:

``` r
data = data.frame(isi=data,id=c(1:length(data)))
data=
  data %>%
  mutate(isi = gsub('\\.','',isi),
         isi = gsub('\\:','',isi)) %>%
  separate(isi,into=c('kota_kab','umk'),sep='Rp') %>%
  mutate(provinsi = 'a') %>%
  select(provinsi,kota_kab,umk)
data$provinsi[1:27] = 'Jawa Barat'
data$provinsi[28:62] = 'Jawa Tengah'
data$provinsi[63:100] = 'Jawa Timur'
data$provinsi[101] = 'DKI Jakarta'
head(data,15)
```

    ##      provinsi                 kota_kab      umk
    ## 1  Jawa Barat      Kabupaten Karawang   4594324
    ## 2  Jawa Barat             Kota Bekasi   4589708
    ## 3  Jawa Barat        Kabupaten Bekasi   4498961
    ## 4  Jawa Barat              Kota Depok   4202105
    ## 5  Jawa Barat              Kota Bogor   4169806
    ## 6  Jawa Barat         Kabupaten Bogor   4083670
    ## 7  Jawa Barat    Kabupaten Purwakarta   4039067
    ## 8  Jawa Barat            Kota Bandung   3623778
    ## 9  Jawa Barat Kabupaten Bandung Barat   3145427
    ## 10 Jawa Barat      Kabupaten Sumedang   3139275
    ## 11 Jawa Barat       Kabupaten Bandung   3139275
    ## 12 Jawa Barat             Kota Cimahi   3139274
    ## 13 Jawa Barat      Kabupaten Sukabumi   3028531
    ## 14 Jawa Barat        Kabupaten Subang   2965468
    ## 15 Jawa Barat       Kabupaten Cianjur   2534798
