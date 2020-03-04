Menghitung Timeline Fieldwork Survey
================

Seperti yang saya sempat bahas di [tulisan
sebelumnya](https://ikanx101.github.io/blog/monte-lagi/), kali ini saya
akan mencoba menghitung *timeline* dari suatu survey dengan memanfaatkan
simulasi **Monte Carlo**.

> *Gimana sih maksudnya?*

Oke, sekarang saya coba bahas **market research 101** dulu yah terkait
dengan *workflow* menjalankan survey *market research*.

# **Workflow Market Research**

Berikut ini adalah proses yang *proper* dalam menjalankan suatu
survey:

![](https://raw.githubusercontent.com/ikanx101/belajaR/master/Bukan%20Infografis/puzzles/Timeline%20Survey/proses%20riset.png
"gbr")

Saya pribadi membagi *flow* di atas menjadi tiga titik kritis yang tidak
boleh salah sama sekali, yakni:

1.  *Formulate problem*; Jika salah dalam memformulasikan masalah, maka
    keseluruhan *cycle* akan menjadi percuma.
2.  *Design research* dan *collect data*; Bayangkan jika kita sudah
    melakukan survey ke 200 orang dan ternyata ada kesalahan sehingga
    harus diulang\!
3.  *Analyze data*; Jangan sampai salah menganalisa yang mengakibatkan
    salah dalam mengambil kesimpulan. Sesuaikan dengan tujuan dan
    masalah yang ingin diselesaikan.

-----

# Proses *Fieldwork*

*Fieldwork* dalam dunia survey adalah suatu proses pekerjaan lapangan
dimana *interviewer* sedang mencari-cari responden yang sesuai dengan
target untuk kemudian diwawancarai sesuai dengan kuesioner yang telah
dibuat sebelumnya.

Lama atau tidaknya suatu proses *fieldwork* tergantung dari berbagai
macam hal, biasanya yang sering terjadi:

1.  **Tingkat kesulitan dan kompleksitas kriteria target responden**.
    Kadangkala kita harus mencari responden yang memiliki kriteria yang
    cukup kompleks. Apalagi jika kriteria tersebut tidak ada patokan
    data sekundernya (di BPS atau AC Nielsen). Contohnya: mencari
    perempuan usia 30 - 45 tahun yang rutin berolahraga dan memiliki
    riwayat penyakit tertentu.
2.  **Keengganan calon responden diwawancara**. Ini juga salah satu
    faktor yang penting. Tidak semua orang mau diwawancarai.
3.  **Area pelaksanaan riset**.
4.  **Force majeure**. Contohnya: kondisi musim hujan (banjir) atau
    kerusuhan (pasca pemilu kemarin).

-----

# *Yuk Simulasi\!*

Sekarang saya akan memberikan contoh bagaimana simulasi bisa digunakan
untuk menghitung berapa lama *fieldwork* suatu survey bisa diselesaikan.

## Jadi begini ceritanya:

-----

> Saya hendak melaksanakan survey di kota **X**. Menurut **AC Nielsen**,
> ada empat kelas sosial ekonomi yang ada di kota itu dengan proporsi
> sebagai berikut: kelas A `3.1%`, kelas B `21.0%`, kelas C `52.4%`, dan
> kelas D `23.4%`.

> Sedangkan saya harus mendapatkan responden dari keempat kelas tersebut
> dengan minimal jumlah tertentu, yakni: kelas A minimal `70` orang,
> kelas B minimal `100` orang, kelas C minimal `150` orang dan kelas D
> minimal `180` orang.

> Menurut BPS, ada sekitar `350.000` orang di kota tersebut.

> Ada `5` orang interviewer yang bertugas mencari dan mewawancara
> responden. Biasanya, setiap interviewer mampu mewawancarai `4` sampai
> `9` orang responden.

Asumsi yang digunakan:

1.  Setiap orang yang hendak diwawancarai punya peluang `30 - 70` untuk
    mau diwawancarai sampai selesai.
2.  Survey dilakukan secara *random*.

-----

## Pertanyaan:

1.  Butuh berapa banyak calon responden yang ditemui agar terpenuhi
    jumlah minimal responden?
2.  Dari jumlah tersebut (dibandingkan dengan populasi BPS), apakah
    memungkinkan dilakukan survey di kota itu?
3.  Jika iya, butuh berapa hari hingga survey bisa selesai?

-----

## Simulasi

Saya akan buat fungsi-fungsi simulasinya yah. Bisa jaid ini bukan fungsi
yang paling *tidy* tapi seharusnya mudah untuk dipahami *yah*.

Pertama-tama, mari kita buat fungsi untuk menebak kelas ekonomi dari
calon responden yang ditemui:

Berikutnya kita kembangkan fungsi pertama dengan memasukkan asumsi
pertama.

Berikutnya kita akan mencari butuh berapa banyak calon responden yang
dibutuhkan agar target responden saya terpenuhi.

> Bagaimana caranya?

Jika dilihat, responden pada kelas sosial ekonomi A memiliki proporsi
terkecil di populasi. Maka dari itu, secara logika, jika kita mencari
sebanyak-banyaknya calon responden secara *random* maka yang paling
terakhir bisa *fulfill* adalah responden kelas A.

> Nanti bisa dibuktikan yah logika ini.

Kita akan membangun suatu fungsi menggunakan *looping* menggunakan
`while()` dan menghitung berapa banyak calon responden yang dibutuhkan.

Contohnya, dalam sekali iterasi untuk memenuhi minimal responden,
dibutuhkan calon responden sebanyak:

Nah, sekarang kita bikin deh simulasinya dalam `100`-an iterasi.

Berapa *expected value* banyaknya calon responden dari simulasi ini:
