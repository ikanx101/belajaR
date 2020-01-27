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
