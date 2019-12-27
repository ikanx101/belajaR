Family Trip To Jogjakarta
================

# 2017

Di pertengahan 2017, saya dan nyonya berencana untuk melakukan *family
trip* pertama yang **jauh**. Mengajak serta Si Sulung yang kala itu
masih TK dan Si Bungsu yang baru 2 tahun.

> Sejauh apa? Hanya ke Jogjakarta.

Tiket pesawat sudah dibeli, Garuda Indonesia (pp). *Voucher* hotel sudah
sudah ada. Tinggal menunggu berangkat saja.

*Qodarullah*, 2 hari sebelum berangkat Si Bungsu demam. Tidak ingin
mengambil resiko, akhirnya perjalanan tersebut kami batalkan.
*Alhamdulillah* semua tiket dan *voucher* bisa di-*refund* walau ada
potongan sana-sini.

# 2019

Pada **Harbolnas** 12.12 kemarin, nyonya melihat ada diskon pembelian
*voucher* hotel di aplikasi **Traveloka**. Seketika saja, kami putuskan
untuk kembali menyelesaikan apa yang dulu pernah mau dilaksanakan:
*family trip to Jogjakarta*. Bedanya, kali ini kami akan melakukannya
melalui perjalanan darat. *InsyaAllah* saya akan menyetir dari rumah ke
Jogjakarta. *Trip*-nya sendiri akan dilakukan pasca liburan tahun baru.

> Jadi saat orang-orang baru selesai liburan tahun baru dan mulai
> beraktivitas normal, kami baru liburan. *Hehehehe*

Seperti perjalanan kemarin ke Malaysia, nyonya segera membuat *trip
itinerary* di sana. Beberapa tempat sudah masuk ke dalam daftar kunjung
kami.

Nah, sebagai suami yang baik, saya akan mencoba membantu nyonya untuk
mengurutkan tempat mana yang harus dikunjungi terlebih dahulu.
Prinsipnya menggunakan **algoritma TSP** seperti yang pernah saya
[*post* beberapa waktu
lalu](https://passingthroughresearcher.wordpress.com/2019/11/18/menentukan-rute-jalan-jalan-paling-optimal-dengan-tsp/).

-----

# Membuat Rute Jalan-Jalan yang Optimal

Berhubung nanti saya yang akan menyetir ke sana-sini, maka penting bagi
saya untuk menemukan rute yang paling optimal, yakni jarak terpendek
agar kaki gak keriting *nginjek-nginjek* kopling (berhubung si Magma
Grey belum tiba di rumah, maka si Putih yang akan jalan).

Selain itu, *trip* ini juga harus banyak mengunjungi destinasi wisata.
Berhubung *trip* kali ini tidak bisa lama-lama karena Si Sulung sudah
masuk sekolah (walaupun pada akhirnya dia bolos di hari-hari pertama
masuk semester dua ini).

Oh iya, setelah berangkat malam dari rumah, kami berencana untuk
menikmati sarapan Nasi Jamblang di Cirebon.

Berikut adalah beberapa destinasi wisata yang ingin dikunjungi:

    ##  [1] "Nasi Jamblang Ibu Nur Cirebon"          
    ##  [2] "Jejamuran Resto"                        
    ##  [3] "HeHa Sky View"                          
    ##  [4] "Sate Klathak Pak Pong"                  
    ##  [5] "Pantai Kukup"                           
    ##  [6] "Ayam Goreng Tojoyo Jalan Mayjend Sutoyo"
    ##  [7] "Museum Ullen Sentalu"                   
    ##  [8] "Taman Wisata Kaliurang"                 
    ##  [9] "Keraton Jogjakarta"                     
    ## [10] "Taman Pintar Jogjakarta"                
    ## [11] "Jalan Malioboro"                        
    ## [12] "Pasar Beringharjo"                      
    ## [13] "Bakmi Mbah Gito"

![peta](https://raw.githubusercontent.com/ikanx101/belajaR/master/Bukan%20Infografis/Family%20Trip%20Jogja/Peta%20Awal.png)

## Mencari *Distance Matrix*

Untuk mencari rutenya, saya akan menggunakan algoritma *Travelling
Salesperson Problem* (**TSP**). Oleh karena itu, saya memerlukan
*distance matrix*. Untuk mendapatkannya, saya akan menggunakan
`library(ggmap)` di **R** yang bisa menghitung jarak *real* berdasarkan
*Google
    Maps*.

    ##          1       2       3       4       5       6       7       8       9
    ## 1    0.000 337.027 350.014 357.610 393.878 353.815 350.204 349.447 356.637
    ## 2  333.760   0.000  33.525  27.537  75.381  19.109  17.142  17.139  16.435
    ## 3  350.612  32.425   0.000  15.629  44.314  20.312  37.262  36.506  18.616
    ## 4  358.580  26.496  15.629   0.000  49.496   9.726  42.515  41.758  10.816
    ## 5  393.905  73.411  44.622  49.362   0.000  55.426  81.815  81.215  57.118
    ## 6  355.174  17.266  17.402   9.935  56.768   0.000  35.077  35.111   2.232
    ## 7  350.792  17.142  38.280  38.395  81.565  29.607   0.000   0.642  28.101
    ## 8  350.150  17.139  37.680  37.790  80.964  29.604   0.642   0.000  28.098
    ## 9  353.306  16.821  19.603  10.431  57.263   2.237  28.162  28.176   0.000
    ## 10 354.342  12.330  17.949  10.248  57.080   2.054  26.871  26.868   1.282
    ## 11 351.671  12.083  18.741  11.066  58.142   3.116  25.919  25.915   1.620
    ## 12 353.135  12.531  18.441  10.793  57.626   2.509  27.402  27.399   0.940
    ## 13 353.264  19.317  13.920   7.330  56.011   3.499  33.323  32.744   5.394
    ## 14 346.657  14.157  16.352  12.736  59.636   9.917  28.098  27.498   6.972
    ## 15 353.924   7.264  26.295  26.987  69.572  16.512  18.833  18.830  15.390
    ## 16 195.136 527.725 541.643 549.239 585.507 545.444 541.833 541.076 544.923
    ##         10      11      12      13      14      15      16
    ## 1  352.977 351.823 352.503 350.630 347.910 354.427 196.220
    ## 2   16.655  11.333  12.012  16.287  13.838   5.724 524.295
    ## 3   18.299  19.845  20.524  13.920  17.556  29.861 541.146
    ## 4   10.962  12.139  12.819   7.326  14.421  25.947 549.115
    ## 5   57.264  58.400  59.080  55.874  61.143  72.812 584.440
    ## 6    2.378   3.515   4.208   3.485   7.387  16.660 545.709
    ## 7   28.321  25.461  27.668  31.415  28.678  18.992 541.326
    ## 8   28.317  26.985  27.665  30.812  28.085  18.988 540.685
    ## 9    1.220   2.747   3.427   5.133   6.797   9.766 543.848
    ## 10   0.000   1.814   2.493   4.463   6.126   8.475 544.877
    ## 11   1.550   0.000   0.680   5.478   5.142   7.522 542.206
    ## 12   0.620   3.040   0.000   4.955   5.773   9.005 546.189
    ## 13   4.790   6.899   7.579   0.000   5.480  14.408 543.799
    ## 14   6.654   5.622   6.302   5.753   0.000   9.075 537.184
    ## 15  15.610   6.906   7.585  11.860   8.738   0.000 544.742
    ## 16 544.606 543.452 544.132 542.259 539.539 546.056   0.000

## Menghitung Jarak Terpendek dengan *TSP*

Sekarang kita akan hitung jarak terpendek dari *matrix* tersebut dengan
algoritma **TSP**. Didapatkan metode yang berhasil mendapatkan rute yang
paling pendek adalah `arbitrary_insertion+two_opt` dengan jarak total
sebagai berikut:

    ## object of class 'TOUR' 
    ## result of method 'arbitrary_insertion+two_opt' for 16 cities
    ## tour length: 1238.084

Bagaimana
    urutannya?

    ##     id                                         alamat       lat     long
    ## 12  12                              Pasar Beringharjo -7.798726 110.3653
    ## 4    4                          Sate Klathak Pak Pong -7.871246 110.3875
    ## 5    5                                   Pantai Kukup -8.130967 110.5558
    ## 3    3                                  HeHa Sky View -7.849754 110.4784
    ## 16  16            Bluebell Residence Sumarekon Bekasi -6.223428 106.9879
    ## 1    1                  Nasi Jamblang Ibu Nur Cirebon -6.714426 108.5550
    ## 8    8                         Taman Wisata Kaliurang -7.598802 110.4264
    ## 7    7                           Museum Ullen Sentalu -7.597866 110.4234
    ## 2    2                                Jejamuran Resto -7.705414 110.3613
    ## 15  15 The Alana Yogyakarta Hotel & Convention Center -7.739414 110.3771
    ## 14  14                          Royal Ambarukmo Hotel -7.782783 110.4028
    ## 13  13                                Bakmi Mbah Gito -7.813363 110.3972
    ## 6    6        Ayam Goreng Tojoyo Jalan Mayjend Sutoyo -7.814691 110.3663
    ## 9.1  9                             Keraton Jogjakarta -7.805284 110.3642
    ## 9    9                             Keraton Jogjakarta -7.805284 110.3642
    ## 10  10                        Taman Pintar Jogjakarta -7.800686 110.3677
    ## 11  11                                Jalan Malioboro -7.792631 110.3658
    ## 121 12                              Pasar Beringharjo -7.798726 110.3653
    ##                     latlon
    ## 12  -7.7987265+110.3653401
    ## 4   -7.8712464+110.3874707
    ## 5   -8.1309675+110.5558448
    ## 3   -7.8497542+110.4783708
    ## 16  -6.2234278+106.9879065
    ## 1   -6.7144257+108.5549963
    ## 8   -7.5988019+110.4263604
    ## 7   -7.5978656+110.4233959
    ## 2     -7.705414+110.361254
    ## 15  -7.7394142+110.3771338
    ## 14  -7.7827826+110.4027951
    ## 13   -7.813363+110.3971575
    ## 6   -7.8146913+110.3662713
    ## 9.1 -7.8052845+110.3642031
    ## 9   -7.8052845+110.3642031
    ## 10   -7.800686+110.3677152
    ## 11  -7.7926306+110.3658442
    ## 121 -7.7987265+110.3653401
