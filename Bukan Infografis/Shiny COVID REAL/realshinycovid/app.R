#
#   ikanx101.github.io proudly present
#   COVID 19 one stop dashboard
#

# ---------------------------------
# panggil library 
library(ggplot2)
library(ggpubr)
library(shinythemes)
library(tidyr)
library(readxl)
library(dplyr)
library(shinydashboard)
library(ggrepel)
library(plotly)
library(leaflet)
# library(shiny)


# ---------------------------------
# ambil data dan semua fungsi
rm(list=ls())
options(scipen = 123)
load('all files.rda')
benua = unique(data_dunia$continent)
data_dunia[is.na(data_dunia)] = 0
kota_jabar = unique(data_jabar$nama_kab)
data_prov_total$latitude = as.numeric(data_prov_total$latitude)
data_prov_total$longitude = as.numeric(data_prov_total$longitude)

# tanggal
tanggal = Sys.Date()
tanggal = as.character(tanggal)

# video update youtube masuk ke sini yah
url = 'https://www.youtube.com/watch?v=YgFsZITZopk'
url = gsub('https://www.youtube.com/watch?v=','',url,fixed = T)


# ---------------------------------
# USER INTERFACE

# header
header = dashboardHeader(title = "COVID 19 Viz for All",
                         titleWidth = 300)

#sidebar menu
sidebar = dashboardSidebar(width = 300,
                           sidebarMenu(
                               menuItem(tabName = 'filterpane',
                                        text = 'Read Me',icon = icon('check')),
                               menuItem(tabName = 'dunia',
                                        text = 'Data Dunia',icon = icon('area-chart')),
                               menuItem(tabName = 'jabar',
                                        text = 'Data Covid 19 Jawa Barat',icon = icon('newspaper-o')),
                               menuItem(tabName = 'indo_harian',
                                        text = 'Data Covid 19 Harian Indonesia',icon = icon('bar-chart')),
                               menuItem(tabName = 'prov',
                                        text = 'Data Provinsi Indonesia',icon = icon('line-chart')),
                               menuItem(tabName = 'simu',
                                        text = 'Simulasi Test Covid 19', icon = icon('gamepad')),
                               menuItem(tabName = 'simu_2',
                                        text = 'Simulasi Test Covid 19 versi II', icon = icon('steam'))
                                       )
            )

# tab Read Me
filterpane = tabItem(tabName = 'filterpane',
                     fluidRow(
                         column(width = 12,
                                h1('Read Me'),
                                h3('Dashboard visualisasi ini berisi updated data dari kasus Covid 19 di Indonesia dan dunia. Sebagaimana yang kita ketahui bersama, gugus tugas percepatan penanganan Covid 19 selalu mengupdate informasi setiap sore. Oleh karena itu, data pada dashboard ini juga akan di-update pada pukul 18.00 WIB setiap harinya.'),
                                h5(paste0('Last update: ',tanggal)),
                                br(),
                                h4('Bagi yang kangen dengan Pak Yuri, silakan tonton dulu press conference hari ini:'),
                                tags$iframe(width="560", height="315", src=paste0("https://www.youtube.com/embed/",url), frameborder="0", allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture", allowfullscreen=NA),
                                h5('courtesy: youtube.com MEDCOM'),
                                br(),
                                h5('Sumber data yang digunakan tertulis di masing-masing tabs.')
                                )
                     )
                     )

# tab dunia
dunia = tabItem(tabName = 'dunia',
                fluidRow(column(width = 12,
                                h1('Data Covid 19 Dunia'),
                                h3('Covid 19 menjadi pandemi global. Mari kita lihat bagaimana kondisi terupdate dari negara lain.'),
                                h4('Sumber data: ourworld in data'),
                                h5(paste0('Last update: ',tanggal)))
                         ),
                br(),
                fluidRow(column(width = 2,
                                checkboxGroupInput('benua','Silakan pilih benua',benua,selected = benua)),
                         column(width = 10,
                                plotOutput('dunia_plot1',height = 200))
                         ),
                br(),
                fluidRow(column(width = 6,
                                leafletOutput('dunia_plot2',height = 450),
                                br(),
                                plotOutput('dunia_plot3',height = 450)),
                         column(width = 6,
                                plotOutput('dunia_plot4',height = 450),
                                br(),
                                plotOutput('dunia_plot5',height = 450))
                        ),
                br(),
                fluidRow(column(width = 4,plotOutput('dunia_plot_final_1',height = 450)),
                         column(width = 8,plotlyOutput('dunia_plot_final_2',height = 450)))
                )

# tab jabar
jabar = tabItem(tabName = 'jabar',
                fluidRow(
                  column(width = 12,
                         h1('Informasi Covid di Jawa Barat'),
                         h4('Data diambil dari website: https://pikobar.jabarprov.go.id/table-case'),
                         h4('Silakan pilih nama kabupaten / kota yang diinginkan untuk mengubah grafik yang ada.'),
                         h5(paste0('Last update: ',tanggal))
                  )
                ),
                fluidRow(
                  column(width = 2,
                         checkboxGroupInput('kota_jabar','Pilih kota / kabupaten di Jawa Barat',
                                            sort(kota_jabar),selected = c('Kabupaten Bekasi',
                                                                          'Kota Bekasi',
                                                                          'Kabupaten Bogor',
                                                                          'Kota Bogor',
                                                                          'Kota Depok')
                         )
                  ),
                  column(width = 10,
                         plotOutput('plotjabar4',height = 400),
                         br(),
                         plotOutput('plotjabar5',height = 300))
                ),
                br(),
                fluidRow(
                  column(width = 12,
                         h1('Grafik Total Akumulasi Provinsi Jawa Barat'),
                         h5('Catatan: smooth trendline dibuat dengan metode loess'))
                ),
                fluidRow(
                  column(width = 6,
                         plotOutput('plotjabar1',height = 400)),
                  column(width = 6,
                         plotOutput('plotjabar2',height = 400))
                )
          )

# tab indo harian
indo_harian = tabItem(tabName = 'indo_harian',
                      fluidRow(column(width = 9,
                                      h1('Data Harian Covid di Indonesia'),
                                      h4('Data diambil dari website: https://kawalcovid19.id/'),
                                      h5(paste0('Last update: ',tanggal))
                                      ),
                               column(width = 3,
                                      h5('Masukkan rentang tanggal yang diinginkan:'),
                                      dateRangeInput('tanggal_indo',
                                                     label = 'Tanggal',
                                                     min = min(data_nasional_harian$tanggal),
                                                     max = max(data_nasional_harian$tanggal),
                                                     start = min(data_nasional_harian$tanggal),
                                                     end = max(data_nasional_harian$tanggal))
                                      )
                               ),
                      fluidRow(
                        column(width = 6,
                               plotOutput('indo_plot1',height = 450)),
                        column(width = 6,
                               plotOutput('indo_plot2',height = 450))
                      ),
                      br(),
                      fluidRow(column(width = 12,
                                      plotOutput('indo_plot3',height = 450)))
                      )


# tab provinsi 
prov = tabItem(tabName = 'prov',
               fluidRow(column(width = 12,
                                      h1('Data Covid per Provinsi di Indonesia'),
                                      h4('Data diambil dari website: https://kawalcovid19.id/'),
                                      h5(paste0('Last update: ',tanggal))
                              )
                      ),
               fluidRow(column(width = 4,
                               leafletOutput('peta_ind',height = 550)
                               ),
                        column(width = 8,
                               plotOutput('plot_prov1',height = 550))
                 
               )
               )

# tab simulasi
simulasi = tabItem(tabName = 'simu',
                   fluidRow(
                     column(width = 12,
                            h1('Simulasi Test Covid 19'),
                            br(),
                            h2('Problem Statement:'),
                            h5('Suatu perusahaan hendak melakukan pengecekan Covid 19 kepada karyawannya secara rapid test. Ada N orang karyawan yang bekerja di lokasi tersebut. Perusahaan bisa saja mengecek keseluruhan karyawan tapi effort yang dilakukan akan semakin besar dan tidak efektif secara waktu dan biaya. Oleh karena itu, apakah bisa ditentukan n orang yang seminimal mungkin tapi tetap memberikan akurasi terbaik:'),
                            h4('Ditemukan adanya karyawan yang positif Covid 19 di perusahaan tersebut!'),
                            br(),
                            h3('Pilihan solusi yang ada:'),
                            h4('1. Perhitungan sampel menggunakan seperti biasa'),
                            h5('Kita bisa menghitung banyaknya sampel yang representatif untuk kasus ini dengan menggunakan tiga informasi dasar: banyak orang di populasi, margin of error, dan confidence interval. Cara menghitungnya bisa menggunakan sample size calculator online.'),
                            h4('2. Menggunakan metode simulasi Monte Carlo'),
                            h5('Kita bisa menghitung banyaknya sampel terkecil yang dibutuhkan agar bisa mendeteksi ada karyawan yang positif Covid 19. Informasi yang dibutuhkan adalah banyak orang di populasi dan asumsi berapa banyak karyawan yang sudah terpapar oleh Covid 19 (atau informasi prevalensi hasil positif dari tested sample). Simulasi ini akan menghitung 80 ribu kemungkinan (kombinasi) yang mungkin muncul dari kondisi yang ada.')
                            )
                     ),
                   fluidRow(
                     column(width = 2,
<<<<<<< HEAD
                            sliderInput('populasi','Banyak karyawan di area kerja:',value = 200,
                                         min = 50, max = 800),
                            sliderInput('sakit','Banyak karyawan yang diduga positif Covid 19:',value = 20,
                                         min = 7, max = 70)),
=======
<<<<<<< HEAD
                            sliderInput('populasi','Banyak karyawan di area kerja:',value = 200,
                                         min = 70, max = 800),
                            sliderInput('sakit','Banyak karyawan yang diduga positif Covid 19:',value = 19,
                                         min = 7, max = 60)),
=======
                            numericInput('populasi','Banyak karyawan di area kerja:',value = 200,
                                         min = 50, max = 500),
                            sliderInput('sakit','Banyak karyawan yang diduga positif Covid 19:',value = 19,
                                         min = 7, max = 50)),
>>>>>>> 554243878705492aaecea6c2dc7c0c198d2a0d15
>>>>>>> a969a89ff12d99eeb8ab3182ff373f98e5800670
                     column(width = 10,
                            plotOutput('simulasi_plot',height = 450))
                   ),
                   br(),
                   fluidRow(
                     column(width = 12,
                            h1('Further Explanation:'),
                            h5('Kalau masih ada yang belum paham, saya coba bantu dengan analogi sebagai berikut ya:'),
                            h5('Misal, di komplek perumahan saya tinggal 200 orang. Saya penasaran, apakah ada orang dari suku betawi yang hidup bersama saya di komplek ini. Cara paling berat untuk membuktikannya adalah dengan bertanya satu-satu ke semua orang yang ada lalu menanyakan suku mereka apa.'),
                            h5('Cara berikutnya adalah dengan menggunakan perhitungan sample size yang biasa kita gunakan utk riset. Ada 3 info yang jadi pertimbangan:'),
                            h5('1. N populasi'),
                            h5('2. Margin or error'),
                            h5('3. Confidence level.'),
                            h5('Cara hitungnya bisa dengan calculator online yang ada d mana2. Contohnya, bisa pakai http://www.raosoft.com/samplesize.html. Contohnya jika dari 200 orang, saya pilih MoE 5% dan CL 95% didapatkan sampel saya sebesar 132 orang.'),
                            h5('Nah, misalkan saya hendak bertanya ke 132 orang secara acak. Bisa jadi pada saat saya bertanya ke orang pertama saya sudah mendapatkan orang betawi. Bisa jadi saya baru mendapatkan orang betawi pada saat bertanya ke orang ke-90. Bisa jadi pada saat orang ke-130.'),
                            h5('Lalu pertanyaannya, apakah kita bisa menghitung peluang kita mendapatkan orang betawi pada saat orang ke berapa? Apakah mungkin kita menghitung sampel size lebih efisien lagi?'),
                            h5('Nah, di sini saya mencoba menghitungnya dengan menggunakan simulasi montecarlo sebanyak 80 rb kali. Kenapa 80 rb kali? Karena saya taruh algoritmanya di awan, jadi 80 rb sudah cukup banyak tanpa harus membebani server gratisan yang dikasih.'),
                            h5('Jadi utk melakukan simulasinya, saya cuma butuh 2 hal:'),
                            h5('1. N populasi,'),
                            h5('2. Dugaan berapa banyak orang betawi yang ada di komplek saya.'),
                            h4('Jadi:'),
                            h5('Simulasi ini memperhitungkan semua kombinasi urutan orang yang akan dites dan murni bertujuan untuk mengetahui apakah benar-benar ada orang betawi di komplek saya tanpa harus menghitung ada berapa banyak (secara total) orang betawi yang ada.'),
                            h5('Jika tujuannya adalah menghitung berapa banyak orang betawi di komplek saya, maka lebih baik melakukan sensus saja.'))
                   )
                   )


# tab simulasi II
simulasi_2 = tabItem(tabName = 'simu_2',
                   fluidRow(
                     column(width = 12,
                            h1('Simulasi Test Covid 19'),
                            br(),
                            h2('Problem Statement:'),
                            h5('Suatu perusahaan hendak melakukan pengecekan Covid 19 kepada karyawannya secara rapid test. Ada N orang karyawan yang bekerja di lokasi tersebut. Perusahaan bisa saja mengecek keseluruhan karyawan tapi effort yang dilakukan akan semakin besar dan tidak efektif secara waktu dan biaya. Oleh karena itu, apakah bisa ditentukan n orang yang seminimal mungkin tapi tetap memberikan akurasi terbaik:'),
                            h4('Ditemukan adanya karyawan yang positif Covid 19 di perusahaan tersebut!'),
                            br(),
                            h3('Pilihan solusi yang ada:'),
                            h4('1. Perhitungan sampel menggunakan seperti biasa'),
                            h5('Kita bisa menghitung banyaknya sampel yang representatif untuk kasus ini dengan menggunakan tiga informasi dasar: banyak orang di populasi, margin of error, dan confidence interval. Cara menghitungnya bisa menggunakan sample size calculator online.'),
                            h4('2. Menggunakan metode simulasi Monte Carlo'),
                            h5('Kita bisa menghitung banyaknya sampel terkecil yang dibutuhkan agar bisa mendeteksi ada karyawan yang positif Covid 19. Informasi yang dibutuhkan adalah banyak orang di populasi dan asumsi berapa banyak karyawan yang sudah terpapar oleh Covid 19 (atau informasi prevalensi hasil positif dari tested sample). Simulasi ini akan menghitung 80 ribu kemungkinan (kombinasi) yang mungkin muncul dari kondisi yang ada.')
                     )
                   ),
                   fluidRow(
                     column(width = 2,
                            sliderInput('populasi_2','Banyak karyawan di area kerja:',value = 200,
                                        min = 50, max = 800),
                            sliderInput('persen_sakit','Persentase positif Covid 19 dari 100 orang yang dites:',value = 12,
                                        min = 1, max = 100)),
                     column(width = 10,
                            plotOutput('simulasi_plot_2',height = 450))
                   )
)

# body
body = dashboardBody(tabItems(filterpane,dunia,indo_harian,jabar,prov,simulasi,simulasi_2))

# ui all
ui = dashboardPage(skin = "red",header,sidebar,body)




server <- function(input, output, session) {
  
  # plot dunia 1
  output$dunia_plot1 = renderPlot({
    
    data_new = 
      data_dunia %>%
      filter(continent %in% input$benua) %>% 
      group_by(location) %>% 
      filter(date == max(date)) %>% ungroup()
    
    data_new %>% arrange(desc(total_cases)) %>% head(15) %>% 
      ggplot(aes(x = reorder(location,-total_cases),y = total_cases)) + 
      geom_col(color = 'darkred',size=1.25,fill = 'white') +
      geom_label(aes(label = paste0(round(total_cases/1000,2),'rb')),size=3) +
      scale_x_discrete(guide = guide_axis(n.dodge=3)) +
      theme_minimal() +
      labs(title = 'Top 15 Negara dengan Jumlah Kasus Covid 19 Terbanyak',
           x = 'Negara',
           y = 'Jumlah Kasus') +
      theme(axis.text.y = element_blank(),
            axis.text.x = element_text(size=10))
  })
  
  # plot dunia 2
  output$dunia_plot2 = renderLeaflet({
    
    data_new = 
      data_dunia %>%
      filter(continent %in% input$benua) %>% 
      group_by(location) %>% 
      filter(date == max(date)) %>% ungroup()
    
    leaflet() %>% addTiles() %>% addCircles(data_new$longitude,
                                            data_new$latitude,
                                            popup = paste0(data_new$location,
                                                           '<br/>Total cases: ',round(data_new$total_cases/1000,1),' ribu',
                                                           '<br/>Total deaths: ', round(data_new$total_deaths/1000,1),' ribu'),
                                            radius = data_new$total_cases)
    
  })
  
  # plot dunia 3
  output$dunia_plot3 = renderPlot({
    data_new = 
      data_dunia %>%
      filter(total_tests_per_thousand>0) %>% 
      filter(continent %in% input$benua) %>% 
      group_by(location) %>% 
      filter(date == max(date)) %>% ungroup()
    
    data_new %>% arrange(desc(total_tests_per_thousand)) %>% head(15) %>% 
      ggplot(aes(x = reorder(location,total_tests_per_thousand),y = total_tests_per_thousand)) + 
      geom_col(color = 'darkgreen',size=1.25,fill = 'green', alpha = .5) +
      geom_label(aes(label = round(total_tests_per_thousand,2)),size=3) +
      theme_minimal() +
      labs(title = 'Top 15 Negara dengan Jumlah Tes per 1000 Orang Terbanyak',
           subtitle = 'Catatan: hanya negara-negara yang melaporkan banyaknya tes',
           x = 'Negara',
           y = 'Jumlah Tes per 1000 orang') +
      theme(axis.text.x = element_blank(),
            axis.text.y = element_text(size=10)) +
      coord_flip()
  })
  
  # plot dunia 4
  output$dunia_plot4 = renderPlot({
    data_new = 
      data_dunia %>%
      filter(continent %in% input$benua) %>% 
      group_by(location) %>% 
      filter(date == max(date)) %>% ungroup()
    
    data_new %>% arrange(desc(total_deaths)) %>% head(15) %>% 
      ggplot(aes(x = reorder(location,-total_deaths),y = total_deaths)) + 
      geom_col(color = 'darkred',size=1.25,fill = 'red', alpha = .5) +
      geom_label(aes(label = paste0(round(total_deaths/1000,2),'rb')),size=3) +
      scale_x_discrete(guide = guide_axis(n.dodge=3)) +
      theme_minimal() +
      labs(title = 'Top 15 Negara dengan Jumlah Kematian Covid 19 Terbanyak',
           x = 'Negara',
           y = 'Jumlah Kematian') +
      theme(axis.text.y = element_blank(),
            axis.text.x = element_text(size=10))
  })
  
  # plot dunia 5
  output$dunia_plot5 = renderPlot({
    data_new = 
      data_dunia %>%
      filter(continent %in% input$benua) %>% 
      group_by(location) %>% 
      filter(date == max(date)) %>% ungroup()
  
    data_new %>% 
      ggplot(aes(x = total_cases_per_million,
                 y = total_deaths)) +
      geom_smooth(method = 'lm',color = 'steelblue',fill = 'blue',alpha=.1) +
      geom_point(aes(size = population)) +
      geom_text(aes(label = location),alpha = .25) +
      scale_color_continuous(type = "viridis") +
      labs(title = 'Apakah banyaknya kasus berpengaruh pada banyaknya kematian?',
           x = 'Total Cases per Million',
           y = 'Total Deaths') +
      theme_minimal() +
      theme(legend.position = 'none')
    
  })
  
  # plot dunia final 1
  output$dunia_plot_final_1 = renderPlot({
    data_new = 
      data_dunia %>%
      filter(continent %in% input$benua) %>% 
      group_by(location) %>% 
      filter(date == max(date)-1) %>% ungroup()
    
    data_new %>% 
      filter(total_tests>0) %>% 
      mutate(new_var = total_cases/total_tests) %>% 
      arrange(desc(new_var)) %>% head(15) %>% 
      ggplot(aes(x = reorder(location,new_var),y = new_var)) + 
      geom_col(color = 'orange',size=1.25,fill = 'yellow', alpha = .5) +
      geom_label(aes(label = paste0(round(new_var*100,2),'%')),size=3) +
      theme_minimal() +
      labs(title = 'Top 15 Negara dengan Ratio\nCases per Test Terbanyak',
           subtitle = 'Catatan: hanya negara-negara yang\nmelaporkan banyaknya tes',
           x = 'Negara',
           y = 'Ratio cases per test') +
      theme(axis.text.x = element_blank(),
            axis.text.y = element_text(size=10)) +
      coord_flip()
  })
  
  # plot dunia final 1
  output$dunia_plot_final_2 = renderPlotly({
    data_new = 
      data_dunia %>%
      filter(continent %in% input$benua)
    
    negara = data_new %>% group_by(location) %>% summarise(total = max(total_cases)) %>% arrange(desc(total)) %>% 
      head(10)
    negara = negara$location
    
    chart = 
    data_new %>%
      filter(location %in% negara) %>% 
      ggplot(aes(x = date,
                 y = total_cases)) +
      geom_line(aes(color=location),size=1) +
      theme_minimal() +
      labs(title = 'Akumulasi Kasus Positif per Negara',
           subtitle = '10 Negara dengan Kasus Positif Terbanyak',
           x = 'Tanggal',
           y = 'Jumlah Kasus',
           color = 'Negara') +
      theme(axis.text.y = element_blank(),
            legend.position = 'bottom')
    
    ggplotly(chart)
  })
  
  
  #plot jabar 4
  output$plotjabar4 = renderPlot({
    data_new = 
      data_jabar %>% 
      filter(nama_kab %in% input$kota_jabar) %>% 
      group_by(nama_kab) %>% 
      summarise(meninggal = sum(meninggal),
                sembuh = sum(sembuh),
                positif = sum(positif),
                odp = sum(odp),
                pdp = sum(pdp))
    
    head_odp = 
      data_new %>% 
      arrange(desc(odp)) %>% 
      head(5)
    head_odp = head_odp$nama_kab
    
    head_pdp = 
      data_new %>% 
      arrange(desc(pdp)) %>% 
      head(5)
    head_pdp = head_pdp$nama_kab
    
    chart_1 = 
      data_new %>% 
      ggplot(aes(x = reorder(nama_kab,positif),
                 y = positif)) +
      geom_col(aes(fill = positif),color = 'black',size = 1.25) +
      geom_label(aes(label = positif),size = 2.5) +
      coord_flip() +
      theme_pubclean() +
      labs(title = 'Berapa banyak total\nkasus positif di\nkota / kabupaten di\nJawa Barat?') +
      theme(axis.title = element_blank(),
            axis.ticks = element_blank(),
            legend.position = 'none',
            axis.text.x = element_blank())
    
    chart_2 = 
      data_jabar %>% 
      filter(nama_kab %in% head_odp) %>%
      filter(nama_kab %in% input$kota_jabar) %>% 
      ggplot(aes(x = tanggal,
                 y = odp)) + 
      geom_line(aes(color = nama_kab)) +
      theme_pubclean() +
      labs(title = "   Total Akumulasi Orang Dalam Pengawasan (ODP)",
           subtitle = '   Selected kota kabupaten di Jawa Barat',
           color = 'Kota / Kabupaten') +
      theme(axis.title = element_blank())
    
    chart_3 = 
      data_jabar %>% 
      filter(nama_kab %in% head_pdp) %>%
      filter(nama_kab %in% input$kota_jabar) %>% 
      ggplot(aes(x = tanggal,
                 y = pdp)) + 
      geom_line(aes(color = nama_kab)) +
      theme_pubclean() +
      labs(title = "   Total Akumulasi Pasien Dalam Pengawasan (PDP)",
           subtitle = '   Selected kota kabupaten di Jawa Barat',
           color = 'Kota / Kabupaten') +
      theme(axis.title = element_blank())
    
    item_1 = ggarrange(chart_2,chart_3,ncol=1,nrow=2,heights = c(1,1))
    ggarrange(chart_1,item_1,ncol=2,nrow=1,widths = c(1,2.5))
    
  })
  
  # plot 5
  output$plotjabar5 <- renderPlot({
    data_new = 
      data_jabar %>% 
      filter(nama_kab %in% input$kota_jabar) %>% 
      group_by(nama_kab) %>% 
      summarise(meninggal = sum(meninggal),
                sembuh = sum(sembuh),
                positif = sum(positif),
                odp = sum(odp),
                pdp = sum(pdp))
    
    head_odp = 
      data_new %>% 
      arrange(desc(meninggal)) %>% 
      head(5)
    head_odp = head_odp$nama_kab
    
    data_jabar %>% 
      filter(nama_kab %in% head_odp) %>%
      filter(nama_kab %in% input$kota_jabar) %>% 
      ggplot(aes(x = tanggal,
                 y = meninggal)) + 
      geom_line(aes(color = nama_kab)) +
      theme_pubclean() +
      theme(legend.position = 'right',
            axis.title = element_blank()) +
      labs(title = 'Total Akumulasi Korban Jiwa Akibat Covid 19',
           subtitle = 'Selected kota kabupaten di Jawa Barat',
           color = 'Kota / Kabupaten')
  })
 
  # plot jabar 1
  output$plotjabar1 <- renderPlot({
    data_new = 
      data_jabar %>% 
      group_by(tanggal) %>% 
      summarise(meninggal = sum(meninggal),
                sembuh = sum(sembuh),
                positif = sum(positif),
                odp = sum(odp),
                pdp = sum(pdp)) 
    
    chart_1 = 
      data_new %>% 
      ggplot(aes(x = tanggal,
                 y = odp)) +
      geom_smooth(method = 'loess',color = 'gray',fill = 'yellow') +
      geom_line(color = 'steelblue',size=1.25) +
      theme_pubclean() +
      labs(title = 'Total Akumulasi ODP di Jawa Barat') +
      theme(axis.title = element_blank()) 
    
    chart_2 = 
      data_new %>% 
      ggplot(aes(x = tanggal,
                 y = pdp)) +
      geom_smooth(method = 'loess',color = 'gray',fill = 'yellow') +
      geom_line(color = 'darkred',size=1.25) +
      theme_pubclean() +
      labs(title = 'Total Akumulasi PDP di Jawa Barat') +
      theme(axis.title = element_blank()) 
    
    ggarrange(chart_1,chart_2,nrow=2)   
  })
  
  # plot jabar 2
  output$plotjabar2 <- renderPlot({
    data_new = 
      data_jabar %>% 
      group_by(tanggal) %>% 
      summarise(meninggal = sum(meninggal),
                sembuh = sum(sembuh),
                positif = sum(positif),
                odp = sum(odp),
                pdp = sum(pdp)) 
    
    chart_1 = 
      data_new %>% 
      ggplot(aes(x = tanggal,
                 y = meninggal)) +
      geom_smooth(method = 'loess',color = 'gray',fill = 'yellow') +
      geom_line(color = 'darkred',size=1.25) +
      theme_pubclean() +
      labs(title = 'Total Akumulasi Korban Meninggal di Jawa Barat') +
      theme(axis.title = element_blank())
    
    chart_2 = 
      data_new %>% 
      ggplot(aes(x = tanggal,
                 y = positif)) +
      geom_smooth(method = 'loess',color = 'gray',fill = 'yellow') +
      geom_line(color = 'black',size=1.25) +
      theme_pubclean() +
      labs(title = 'Total Akumulasi Positif Covid 19 di Jawa Barat') +
      theme(axis.title = element_blank())
    
    
    ggarrange(chart_1,chart_2,nrow=2)   
  })
 
  # indo plot 1
  output$indo_plot1 = renderPlot({
    data_nasional_harian %>% 
      filter(tanggal >= input$tanggal_indo[1], tanggal <= input$tanggal_indo[2]) %>% 
      ggplot(aes(x = tanggal,
                 y = kasus_baru)) +
      geom_smooth(method = 'loess',color = 'darkred',fill = 'red',alpha=.5) +
      geom_col(alpha=.45) +
      geom_text(aes(y = kasus_baru+50,label = kasus_baru),angle=90,size=3,color = 'steelblue') +
      theme_minimal() +
      labs(title = 'Tren Penambahan Kasus Baru Harian Indonesia',
           x = 'Tanggal',
           y = 'Penambahan Kasus Baru',
           subtitle = 'Trendline menggunakan metode Loess')
  })
    
  # indo plot 2
  output$indo_plot2 = renderPlot({
    data_nasional_harian %>% 
      filter(tanggal >= input$tanggal_indo[1], tanggal <= input$tanggal_indo[2]) %>% 
      ggplot(aes(x = tanggal,
                 y = jumlah_orang_diperiksa)) +
      geom_smooth(method = 'loess',color = 'darkred',fill = 'red',alpha=.5) +
      geom_col(alpha = .45) +
      geom_text(aes(y = jumlah_orang_diperiksa+50,label = jumlah_orang_diperiksa),angle=90,size=3,color = 'steelblue') +
      theme_minimal() +
      labs(title = 'Akumulasi Pemeriksaan Orang Indonesia',
           x = 'Tanggal',
           y = 'Akumulasi Pemeriksaan',
           subtitle = 'Trendline menggunakan metode Loess')
  })
  
  # indo plot 3
  output$indo_plot3 = renderPlot({
    data_nasional_harian %>% 
      filter(tanggal >= input$tanggal_indo[1], tanggal <= input$tanggal_indo[2]) %>% 
      mutate(ratio = total_kasus/jumlah_orang_diperiksa,
             ratio = round(ratio*100,2)) %>% 
      ggplot(aes(tanggal,ratio)) +
      geom_line(color = 'darkred',size=2) +
      geom_text_repel(aes(label = paste0(ratio,'%')),alpha=.5) +
      theme_minimal() +
      labs(title = 'Berapa rasio orang yang positif dari total semua orang yang diperiksa?',
           subtitle = 'Data yang digunakan adalah akumulasi positif dan akumulasi tes harian',
           x = 'Tanggal',
           y = 'Rasio') +
      theme(axis.text.y = element_blank())
  })
  
  # plot indonesia
  output$peta_ind = renderLeaflet({
    
    leaflet() %>% addTiles() %>% addCircles(data_prov_total$longitude,
                                            data_prov_total$latitude,
                                            popup = paste0(data_prov_total$provinsi_asal_2,
                                                           '<br/>Total cases: ',round(data_prov_total$kasus/1000,2),' ribu',
                                                           '<br/>Total deaths: ', round(data_prov_total$kematian/1000,2),' ribu',
                                                           '<br/>Total recovered: ', round(data_prov_total$sembuh/1000,2),' ribu'),
                                            radius = data_prov_total$kasus*10)
    
  })
  
  # Plot prov
  output$plot_prov1 = renderPlot({
    new = 
      data_prov_total %>% 
      mutate(ratio_sembuh = sembuh/kasus,
             ratio_mati = kematian/kasus,
             ratio_fin = ratio_sembuh - ratio_mati,
             ratio_fin = round(ratio_fin*100,2))
    rata = mean(new$ratio_fin)
    
    new %>% 
      mutate(penanda = ifelse(ratio_fin<=rata,'red','blue')) %>% 
      ggplot(aes(x = reorder(provinsi_asal_2,ratio_fin),
                 y = ratio_fin)) +
      geom_col(aes(fill = penanda),color = 'black',size=.75) +
      scale_fill_brewer(palette = 'Set2') +
      geom_hline(yintercept = rata,color = 'darkgreen',size=1.25) +
      geom_label(aes(color = penanda,label = paste0(ratio_fin,'%')),size = 3) +
      coord_flip() +
      theme_minimal() +
      theme(axis.text.x = element_blank(),
            axis.title.y = element_blank(),
            legend.position = 'none') +
      labs(y = 'Rasio Sembuh dan Meninggal',
           title = 'Dari kasus yang ada, berapa selisih rasio kesembuhan dan rasio korban jiwa per provinsi?',
           subtitle = 'Lebih banyak penderita yang sembuh atau penderita yang meninggal?')
  })
  
  # simulasi 1
  
  output$simulasi_plot = renderPlot({
    simulasi = function(n_tes){
      n = 400 #pengulangan
      n_sakit = input$sakit #banyak orang sakit 
      total = input$populasi # total karyawan
      temp = c(0)
      for(i in 1:n){
        karyawan = sample(c(1,0),total,prob = c(n_sakit/total,(total-n_sakit)/total),replace = T)
        tes = sample(karyawan,n_tes)
        hasil = sum(tes)
        hasil = ifelse(hasil>1,1,0)
        temp = c(temp,hasil)
      }
      sum(temp)/n*100
    }
    
    data = data.frame(n_tes = c(1:input$populasi))
    data$sensitivity = sapply(data$n_tes,simulasi)
    n_min = data %>% filter(sensitivity > 98) %>% select(n_tes)
    n_min = min(n_min$n_tes)
    
    subjudul = paste0('\nDi suatu pabrik berisi ',input$populasi,' orang. Diduga ada ',input$sakit,' orang yang terpapar Covid 19.\nMonteCarlo Simulation 80.000 times.')
    data %>% 
      ggplot(aes(x = n_tes,
                 y = sensitivity)) +
      geom_smooth(method = 'loess') +
      geom_line(color = 'black') +
      labs(title = paste0('Berapa banyak karyawan yang harus dites?\nJawab: Pilih ',n_min,' orang secara acak!'),
           subtitle = subjudul,
           caption = 'Simulated and Visualized\nusing R',
           x = 'Banyak tes',
           y = 'Peluang mendapat karyawan yang positif\n') +
      ggthemes::theme_economist() +
      theme(axis.text = element_text(size=10))
    
  })
  
  # simulasi 2
  
  output$simulasi_plot_2 = renderPlot({
    simulasi = function(n_tes){
      n = 400 #pengulangan
      n_sakit = input$persen_sakit #banyak orang sakit 
      total = input$populasi_2 # total karyawan
      temp = c(0)
      for(i in 1:n){
        karyawan = sample(c(1,0),total,prob = c(n_sakit/100,1-(n_sakit/100)),replace = T)
        tes = sample(karyawan,n_tes)
        hasil = sum(tes)
        hasil = ifelse(hasil>1,1,0)
        temp = c(temp,hasil)
      }
      sum(temp)/n*100
    }
    
    data = data.frame(n_tes = c(1:input$populasi))
    data$sensitivity = sapply(data$n_tes,simulasi)
    n_min = data %>% filter(sensitivity > 98) %>% select(n_tes)
    n_min = min(n_min$n_tes)
    
    subjudul = paste0('\nDi suatu pabrik berisi ',input$populasi,' orang.\nMonteCarlo Simulation 80.000 times.')
    data %>% 
      ggplot(aes(x = n_tes,
                 y = sensitivity)) +
      geom_smooth(method = 'loess') +
      geom_line(color = 'black') +
      labs(title = paste0('Berapa banyak karyawan yang harus dites?\nJawab: Pilih ',n_min,' orang secara acak!'),
           subtitle = subjudul,
           caption = 'Simulated and Visualized\nusing R',
           x = 'Banyak tes',
           y = 'Peluang mendapat karyawan yang positif\n') +
      ggthemes::theme_economist() +
      theme(axis.text = element_text(size=10))
    
  })
  
  
}


# ---------------------------------
# Run the application 
shinyApp(ui = ui, server = server)