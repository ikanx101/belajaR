Training Day 1: R-Series
================

![alt
text](https://bookdown.org/moh_rosidi2610/Metode_Numerik/images/r-icon.png
"logo")

# 1\. Pendahuluan

**R** merupakan salah satu bahasa pemrograman yang biasa digunakan untuk
menyelesaikan permasalahan terkait dengan data. Kita bisa membuat model
prediksi (*machine learning*, *artificial intelligence*, dan *deep
learning*) sampai membuat algoritma automasi menggunakan **R**.

> Apa perbedaan R dan Python?

Salah satu kelebihan **R** adalah:

> R is made by statistician for statistician.

Setiap *package* atau *library* yang di-*launching* di **R** biasanya
disertakan dengan jurnal ilmiah sehingga kita bisa dengan yakin
memakainya.

**R** tersedia secara *open source* sehingga *software* ini gratis dan
dikembangkan secara massal oleh komunitas-komunitas di seluruh dunia.
Sehingga *package* atau *library* yang disediakan untuk analisis
statistika dan analisa numerik juga sangat lengkap dan terus bertambah
setiap saat.

Materi *training* ini saya kumpulkan dari berbagai sumber dan saya
*customize* sesuai dengan kebutuhan **Nutrifood** berdasarkan pengalaman
saya bergelut dengan data (dari mulai data pabrik hingga *finance*).
Semoga menjadi manfaat bagi *Nutrifooders* semua.

## 1.1 Sejarah

**R** Merupakan bahasa yang digunakan dalam komputasi statistik yang
pertama kali dikembangkan oleh *Ross Ihaka* dan *Robert Gentlement* di
*University of Auckland New Zealand* yang merupakan akronim dari nama
depan kedua pembuatnya. Sebelum **R** dikenal ada **S** yang
dikembangkan oleh *John Chambers* dan rekan-rekan dari *Bell
Laboratories* yang memiliki fungsi yang sama untuk komputasi statistik.
Hal yang membedakan antara keduanya adalah **R** merupakan sistem
komputasi yang bersifat gratis.

## 1.2 Fitur dan Karakteristik

Sama halnya dengan bahasa pemograman lainnya. Berbeda bahasa berarti
berbeda peraturan / cara menulis *code* (algoritma). Tapi jangan
khawatir, dengan memanfaatkan *tidy principle* di **R**, kita bisa
menulis algoritma dengan mudah (bagi kita dan pembaca algoritmanya).

> Oleh karena itu, menurut saya **R** menawarkan *learning curve* yang
> jauh lebih baik dibandingkan *Python*.

Beberapa karakter dari **R** adalah sebagai berikut:

1.  Bahasa **R** bersifat *case sensitive*. Setiap perbedaan cara
    penulisan (kapital vs non kapital) akan membedakan suatu objek.
    Contoh:

<!-- end list -->

``` r
x = 'Nutrifood'
y = 'nutrifood'
x == y
```

    ## [1] FALSE

2.  Segala sesuatu yang ada pada program **R** akan diangap sebagai
    objek. konsep objek ini sama dengan bahasa pemrograman berbasis
    objek yang lain seperti *Java*, *C++*, *Python*, dll. Perbedaannya
    adalah bahasa **R** relatif lebih sederhana dibandingkan bahasa
    pemrograman berbasis objek yang lain.
3.  *Interpreted language* atau *script*. Bahasa **R** memungkinkan
    pengguna untuk melakukan kerja pada **R** tanpa perlu melakukan
    *compile* menjadi *executionable* file (.exe).
4.  Mendukung proses *loop*, *decision making*, dan menyediakan berbagai
    jenis operator (aritmatika, logika, dll).
5.  Mendukung *export* dan *import* berbagai *format file*, seperti:
    `.txt`, `.xlsx`, `.csv`, `.json`, dll.
6.  Mudah ditingkatkan melalui penambahan fungsi atau *library*.
    Penambahan ini dapat dilakukan secara *online* melalui **CRAN** atau
    melalui sumber seperti **github**.
7.  Menyedikan berbagai fungsi untuk keperluan visualisasi data.
    Visualisasi data pada **R** dapat menggunakan *library* bawaan atau
    lainnya seperti `ggplot2`, `ggvis`, `plotly`, dll.

## 1.3 Kelebihan dan Kekurangan **R**

Selain karena **R** dapat digunakan secara gratis terdapat kelebihan
lain yang ditawarkan, antara lain:

1.  *Protability*, penggunaan *software* dapat digunakan kapanpun tanpa
    terikat oleh masa berakhirnya lisensi.
2.  *Multiplatform*, **R** bersifat *Multiplatform Operating Systems*,
    dimana **R** bisa dijalankan di OS manapun. Baik Windows, iOS,
    Linux, Raspbian, bahkan
    [Android](https://passingthroughresearcher.wordpress.com/2019/07/30/install-r-3-5-2-di-android/)\!
    Dengan fitur yang sama (tidak ada perbedaan fitur di semua OS).
3.  *Programable*, pengguna dapat membuat fungsi dan metode baru atau
    mengembangkan modifikasi dari analisis statistika yang telah ada
    pada sistem **R**.
4.  Fasiltas grafik yang lengkap.

Adapun kekurangan dari R antara lain:

  - *Point and Click GUI*, interaksi utama dengan **R** bersifat **CLI**
    (*Command Line Interface*), walaupun saat ini telah dikembangkan
    *library* yang memungkinkan kita berinteraksi dengan **R**
    menggunakan **GUI** (*Graphical User Interface*) sederhana
    menggunakan `library(R-Commander)` yang memiliki fungsi yang
    terbatas.

## 1.4 R vs R Studio

Pada dasarnya, *software* **R** bisa di-*download* dan di-*install*
langsung dari situs
[CRAN](https://cran.r-project.org/bin/windows/base/). *Software* **R**
ini bersifat **CLI**.

> Bayangkan Anda membuka aplikasi **notepad**. Putih dan bersih kan?

Seperti itulah *software* **R**.

Bagi Kamu yang kaget dan tidak terbiasa melihat tampilan yang
*intimidating* seperti itu, Kamu bisa meng-*install software* **R
Studio**. Sebuah *software* yang bisa membuat **R** terlihat lebih *user
friendly*. **R Studio** bisa di-*download* [di
sini](https://rstudio.com/products/rstudio/download/).

Kelebihan R Studio antara lain:

1.  *Free*, kita bisa memilih versi gratis dari **R Studio** tanpa ada
    pengurangan fitur dasar dari **R**.
2.  *R Studio Cloud*, tersedia layanan *cloud* sehingga bisa diakses dan
    digunakan menggunakan *browser* di *gadget* manapun. Layanan *cloud*
    ini bisa diakses [di sini](https://rstudio.cloud) dan dikoneksikan
    ke akun **github** Kamu.
3.  *Shiny Apps*, kita bisa membuat *apps* berbasis *web* dari **R**.
    *Apps* ini bisa dijadikan *dashboard* atau mesin kalkulasi otomatis.
    Tergantung seberapa jauh Kamu membuat *coding* algoritmanya.
4.  *R Markdown*, ini fitur yang paling saya sukai. Bahkan untuk menulis
    *web* ini, saya menggunakan *R Markdown*. Output files -nya beragam,
    mulai dari `docx`, `pptx`, `pdf`, `html`, `md`, dll. Bahkan kita
    bisa membuat [*e-book*](https://bookdown.org/) dengan memanfaatkan
    `library(bookdown)`.

-----

# Referensi

1.  [Metode Numerik Menggunakan R Untuk
    TeknikLingkungan](https://bookdown.org/moh_rosidi2610/Metode_Numerik/),
    Mohammad Rosidi: R bookdown.
2.  [Cara Install R di
    Android](https://passingthroughresearcher.wordpress.com/2019/07/30/install-r-3-5-2-di-android/),
    Ikang Fadhli personal blog.
3.  [Install R base for
    Windows](https://cran.r-project.org/bin/windows/base/).
4.  [Install R Studio](https://rstudio.com/products/rstudio/download/).
5.  [R Studio Cloud](https://rstudio.cloud/).
6.  [Bookdown, e-book from R Markdown](https://bookdown.org/).
