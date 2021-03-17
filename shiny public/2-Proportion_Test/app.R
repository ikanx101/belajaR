#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)

# Function utama
cek.dua.proporsi.donk = function(kelo_1,
                                 trial_1,
                                 n1,
                                 kelo_2,
                                 trial_2,
                                 n2){
    hasil = prop.test(c(trial_1,trial_2),
                      c(n1,n2))
    a1 = ("Ada dua proporsi yang dicek, yakni: ")
    a2 = (paste0("Proporsi dari ",kelo_1," sebesar: "))
    a3 = (paste0(round(hasil$estimate[1]*100,2),"%. "))
    a4 = (paste0("Proporsi dari ",kelo_2," sebesar: "))
    a5 = (paste0(round(hasil$estimate[2]*100,2),"%. "))
    a6 = ("Hasil uji signifikansinya: ")
    kesimpulan = ifelse(hasil$p.value < 0.5,
                        "Proporsinya BERBEDA SIG. ",
                        "TIDAK ADA perbedaan sig. ")
    a7 = paste0(kesimpulan)
    print(paste(a1,a2,a3,a4,a5,a6,a7))
}

# Define UI for application that draws a histogram
title_pane = titlePanel("2 Proportion Test")

is1 = fluidRow(column(width = 6,
                      h3("Mengenal 2 Proportion Test"),
                      h4("Seringkali kita berhadapan dengan data berjenis kualitatif, yakni data yang tidak bisa jumlah, kurang, bagi atau kali. Tapi data tersebut masih bisa kita cacah (counting)."),
                      h4("Masalah yang biasa kita temui adalah membandingkan dua proporsi dan menentukan apakah perbedaan yang ada signifikan atau tidak.")),
               column(width = 6,
                      h3("Contoh Kasus"),
                      h5("Suatu perusahaan otomotif hendak mengiklankan mobil varian barunya. Ada dua pilihan channel yang bisa dipilih, yakni: Youtube dan Instagram."),
                      h5("Dari hasil survey yang mereka lakukan, didapatkan data sebagai berikut:"),
                      h6("- 50 dari 89 orang (56.2%) target marketnya rutin menonton Youtube."),
                      h6("- 63 dari 101 orang (62.3%) target marketnya rutin melihat Instagram."),
                      h5("Apakah tepat jika perusahaan tersebut beriklan di Instagram?"))
               )

is2 = fluidRow(column(width = 12,
                      h3("Penjelasan"),
                      h4("Proporsi yang lebih tinggi belum cukup untuk kita bisa mengambil kesimpulan!"),
                      h4("Kita harus buktikan terlebih dahulu, apakah perbedaan yang ada tersebut signifikan atau tidak."),
                      h3("Masukkan informasi-informasi yang dibutuhkan:"),
                      column(width = 4,
                             textInput("kel_1","Masukkan nama kelompok I: (opsional)"),
                             textInput("sem_1","Masukkan semesta kelompok I:"),
                             textInput("ev_1","Masukkan banyaknya kejadian pada kelompok I:")),
                      column(width = 4,
                             textInput("kel_2","Masukkan nama kelompok II: (opsional)"),
                             textInput("sem_2","Masukkan semesta kelompok II:"),
                             textInput("ev_2","Masukkan banyaknya kejadian pada kelompok II:")),
                      column(width = 4,
                             h4("Contoh Pengisian:"),
                             h5("Menggunakan kasus di atas, maka nilai yang harus dimasukkan ke dalam kalkulator adalah:"),
                             h6("Nama kelompok I: Youtube."),
                             h6("Semesta kelompok I: 89."),
                             h6("Kejadian kelompok I: 50"),
                             h6("Nama kelompok II: IG."),
                             h6("Semesta kelompok II: 101."),
                             h6("Kejadian kelompok II: 63"))
                      )               
               )

is_3 = fluidRow(h2("Hasil Kalkulasi"),
                h3(textOutput("hasil")))

ui <- fluidPage(title_pane,is1,is2,is_3)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$hasil = renderText({
        cek.dua.proporsi.donk(input$kel_1,
                              as.numeric(input$ev_1),
                              as.numeric(input$sem_1),
                              input$kel_2,
                              as.numeric(input$ev_2),
                              as.numeric(input$sem_2))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
