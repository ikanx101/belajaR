---
title: "Time Series Analysis Tropicana Slim versi 2.0"
author: "Market Research Dept. Nutrifood Indonesia"
date: "December 27, 2019"
output:
  html_document:
    toc: true
    toc_depth: 2
    toc_float:
      collapsed: false
    number_sections: true
    theme: united
    highlight: textmate
    df_print: paged
    keep_md: true
---




# Pendahuluan

Berkaitan dengan _capstone project_ Tropicana Slim, kali ini kita akan melakukan analisa _time series_ dari data _market share_ produk Tropicana Slim dan kompetitornya (Diabetasol).

## Tujuan

Ada beberapa tujuan yang ingin dilihat dari analisa ini:

1. _Total market sweetener_ turun atau tidak?
2. _Trend per brands_ turun atau tidak? _Brands_ yang dipantau: Tropicana Slim Classic, Tropicana Slim Diabtx, Diabetasol, dan Nulife.
3. _Brands_ mana yang berpengaruh besar terhadap perubahan _trend_ Tropicana Slim Classic dan Tropicana Slim Diabtx? Apakah ada kausalitas _pattern_ data _time series_ antara Tropicana Slim dan Diabetasol?

## Data yang dipakai

Data yang kita pakai adalah data _market share_ yang disimpan di _shared folder_ divisi sales per __26 Desember 2019__:

`National$\20. Key Account\20. Key Account\03. Data outlet\02. Data Selling Out Outlet\2019`

Data tersebut adalah data _market share_ dari empat _parent_, yakni:

1. LION.
2. Alfamart.
3. Indomaret.
4. Alfamidi.

## Analisa yang dipakai

Untuk menjawabkan tujuan-tujuan di atas, kita akan menggunakan dua macam analisa _time series_ yakni:

1. _Time series decomposition_ menggunakan [_STL decomposition_](https://otexts.com/fpp2/stl.html#ref-Cleveland1990).
2. Analisa kausalitas antara dua data _time series_ menggunakan [_Granger-Causality_](https://www.r-bloggers.com/chicken-or-the-egg-granger-causality-for-the-masses/). Bacaan versi [e-book](https://www.dropbox.com/s/zezul3v6pw88qwv/%28Wiley%20Series%20in%20Probability%20and%20Statistics%29%20Walter%20Enders-Applied%20Econometric%20Time%20Series-Wiley%20%282014%29%5B3%5D.pdf?dl=0).

## Catatan khusus

1. Khusus mengenai dekomposisi, jika hasil dekomposisi dinilai masih memiliki pola _seasonal_, maka perlu dibuat dekomposisi kembali hingga tercapai _smooth line_.
2. Data _time series_ diasumsikan _stationer_. 

___

# _Pre-Analysis Time Series_

Sebelum kita memulai analisa data _time series_-nya, kita akan melakukan beberapa proses cek terlebih dahulu.

## Mencari _Time Frame_ yang Sama

Sebelum memulai, kita akan cek terlebih dahulu ketersediaan data dari masing-masing brand tersebut. Apakah selalu tersedia di setiap waktu?

> Jika tidak (ada yang bolong), maka kita hanya akan lakukan analisa data pada _timeframe_ yang sama-sama ada datanya.

### Tropicana Slim Diabtx 

Data Tropicana Slim Diabtx tersedia mulai dari:

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["tahun"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["bulan"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["total.sales"],"name":[3],"type":["dbl"],"align":["right"]}],"data":[{"1":"2014","2":"1","3":"3331572255"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div><div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["tahun"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["bulan"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["total.sales"],"name":[3],"type":["dbl"],"align":["right"]}],"data":[{"1":"2019","2":"11","3":"5511710342"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

### Tropicana Slim Classic 

Data Tropicana Slim Classic tersedia mulai dari:

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["tahun"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["bulan"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["total.sales"],"name":[3],"type":["dbl"],"align":["right"]}],"data":[{"1":"2014","2":"1","3":"2125873702"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div><div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["tahun"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["bulan"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["total.sales"],"name":[3],"type":["dbl"],"align":["right"]}],"data":[{"1":"2019","2":"11","3":"3280058913"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
