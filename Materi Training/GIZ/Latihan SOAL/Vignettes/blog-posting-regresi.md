Price Elasticity
================

# Old but not obsolete

Begitulah kira-kira kondisi dari analisa regresi linear. Walaupun
usianya sudah sangat jadul tapi sampai sekarang analisa ini masih sering
dipakai banyak orang karena kemudahan dalam melakukan dan
menginterpretasikannya.

Analisa ini digunakan untuk memodelkan hubungan kausalitas antara
variabel independen terhadap dependen. Biasanya, regresi linear
dinotasikan dalam formula: `y = a*x + b`.

Di mana `y` dan `x` merupakan data numerik yang biasanya memiliki
korelasi kuat (baik positif atau negatif). Kenapa demikian? Karena salah
satu *goodness of fit* dari model regresi linear adalah **R-Squared**
yang didapatkan dari kuadrat dari angka korelasi.

Bukan cuma memodelkan `x` dan `y` saja. Untuk beberapa kasus, kita bisa
membuat *optimization* dari model regresi linear ini.

Salah satu contoh yang paling sering saya berikan adalah model *price
elasticity*.

Secara logika, semakin tinggi harga suatu barang, semakin sedikit orang
yang akan membelinya. Secara simpel kita bisa bilang bahwa `harga`
berkorelasi negatif dengan `sales_qty`. Tapi untuk mengatakan ada
kausalitas antara `harga`dan `sales_qty`, kita harus cek dulu model
regresinya.

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
cor(data$harga,data$qty)
```

    ## [1] -0.8323464

Ternyata angka korelasinya kuat negatif. Sekarang kita coba buat model
regresinya.

``` r
model_reg = lm(qty~harga,data = data)
model_reg
```

    ## 
    ## Call:
    ## lm(formula = qty ~ harga, data = data)
    ## 
    ## Coefficients:
    ## (Intercept)        harga  
    ##     17.1082      -0.4849

``` r
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

# sekarang kita lihat goodness of fit dari modell regresi

# pertama R-squared, diambil dari nilai multiple R-squared

# atau bisa juga dihitung menggunakan:

r\_squared = modelr::rsquare(model\_reg,data) \# apa arti dari
r\_squared?

# lalu ada p-value ~ 0

# karena p-value \< 0.05 artinya model berpengaruh terhadap sales qty-nya

# ada yang namanya mean absolut error

mean\_absolut\_error = modelr::mae(model\_reg,data) \#harus bernilai
kecil

# 

# METODE LAIN

# cara membangun model regresi menggunakan visual grafis

data %\>% ggplot(aes(x=harga,y=qty)) + geom\_point() +
geom\_smooth(method=‘lm’) + theme\_pubclean() +
stat\_regline\_equation(label.y = 7,aes(label = paste(..eq.label..,
..rr.label.., sep = “~~~~”))) + labs(title = ‘Model Regresi: Price
Elasticity Index’, subtitle = ‘Data harga vs sales qty’, caption =
‘Created using R’, x = ‘Harga produk (dalam ribu rupiah)’, y = ‘Sales
Qty’) + theme(axis.text = element\_blank(), axis.ticks =
element\_blank(), plot.title =
element\_text(size=25,face=‘bold.italic’), plot.caption =
element\_text(size=10,face=‘italic’))
