Another Puzzle: Deadly Board Game
================

Sudah baca *puzzles* saya sebelumnya di
[sana](https://ikanx101.github.io/blog/puzzle-usia/) dan
[sini](https://ikanx101.github.io/blog/elevator-problem/)?

Dua *puzzles* tersebut adalah beberapa contoh aplikasi simulasi **Monte
Carlo** untuk menyelesaikan masalah *real*.

Sekarang, saya punya *puzzle* lagi. Begini ceritanya:

-----

> Suatu waktu, saya mengunjungi Kerajaan Wakanda. Singkat cerita, saya
> dituduh melakukan kejahatan. Saya diberikan kesempatan untuk lolos
> dari hukuman jika mau bermain dalam *deadly board game*.

Bagaimana cara bermainnya:

  - *Board* berisi kotak bernomor dari satu hingga tiga puluh secara
    berurutan.
      - Kota nol menjadi posisi awal saya.
  - Saya diberikan:
      - Tiga koin.
      - Satu dadu.
      - Satu bidak.
  - Saya harus memilih dan menaruh tiga koin di tiga kotak berbeda.
      - Setelah menaruh koin, saya tidak diperbolehkan untuk
        mengubahnya.
  - Lalu saya diharuskan melempar dadu.
      - Saya akan memindahkan bidak sesuai dengan angka yang keluar di
        dadu.
      - Proses ini terus berulang hingga selesai tiga puluh kotak
        dilalui oleh bidak saya.
  - Seandainya dalam seluruh proses ini, bidak saya **tidak pernah sama
    sekali berhenti di kotak yang memiliki koin**, maka saya akan
    dieksekusi.
      - Kebalikannya, jika dalam seluruh prosesnya bidak saya pernah
        minimal sekali berhenti di kotak yang memiliki koin, maka saya
        selamat.

-----

## Pertanyaannya:

> Di kotak nomor berapa saja saya harus menaruh koin?

-----

## Ada yang punya ide bagaimana cara menjawabnya?

> Kita akan mencari **tiga angka** yang memiliki peluang paling tinggi
> keluar dengan kondisi seperti di atas.

Bagaimana caranya? Dengan simulasi **Monte Carlo** kembali.

Berikut adalah contoh saat saya melempar dadu satu putaran:

    ##   lempar_dadu posisi_bidak
    ## 1           5            5
    ## 2           6           11
    ## 3           4           15
    ## 4           2           17
    ## 5           1           18
    ## 6           6           24
    ## 7           3           27

Bagaimana jika saya melempar dadu 5 putaran?

    ## [1] "Putaran ke: 1"
    ##   lempar_dadu posisi_bidak
    ## 1           5            5
    ## 2           6           11
    ## 3           6           17
    ## 4           1           18
    ## 5           6           24
    ## 6           6           30
    ## [1] "Putaran ke: 2"
    ##    lempar_dadu posisi_bidak
    ## 1            5            5
    ## 2            1            6
    ## 3            3            9
    ## 4            1           10
    ## 5            2           12
    ## 6            1           13
    ## 7            2           15
    ## 8            2           17
    ## 9            5           22
    ## 10           2           24
    ## 11           3           27
    ## [1] "Putaran ke: 3"
    ##   lempar_dadu posisi_bidak
    ## 1           2            2
    ## 2           3            5
    ## 3           2            7
    ## 4           4           11
    ## 5           5           16
    ## 6           4           20
    ## 7           4           24
    ## 8           3           27
    ## [1] "Putaran ke: 4"
    ##    lempar_dadu posisi_bidak
    ## 1            1            1
    ## 2            2            3
    ## 3            6            9
    ## 4            2           11
    ## 5            1           12
    ## 6            3           15
    ## 7            4           19
    ## 8            3           22
    ## 9            4           26
    ## 10           2           28
    ## [1] "Putaran ke: 5"
    ##    lempar_dadu posisi_bidak
    ## 1            6            6
    ## 2            3            9
    ## 3            3           12
    ## 4            2           14
    ## 5            1           15
    ## 6            1           16
    ## 7            2           18
    ## 8            4           22
    ## 9            2           24
    ## 10           4           28
