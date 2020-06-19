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
load('all files.rda')
benua = unique(data_dunia$continent)
data_dunia[is.na(data_dunia)] = 0
kota_jabar = unique(data_jabar$nama_kab)


# tanggal
tanggal = Sys.Date() - 1
tanggal = as.character(tanggal)

# video update youtube masuk ke sini yah
url = 'https://www.youtube.com/watch?v=WaF_YcKMF6A'
url = gsub('https://www.youtube.com/watch?v=','',url,fixed = T)
url


# ---------------------------------
# USER INTERFACE

# header
header = dashboardHeader(title = "COVID 19 Viz for All",
                         titleWidth = 300)

#sidebar menu
sidebar = dashboardSidebar(width = 300,
                           sidebarMenu(
                               menuItem(tabName = 'filterpane',
                                        text = 'Read Me'),
                               menuItem(tabName = 'dunia',
                                        text = 'Data Dunia'),
                               menuItem(tabName = 'jabar',
                                        text = 'Data Covid 19 Jawa Barat')
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
                                h5('courtesy: youtube.com media indonesia')
                                )
                     )
                     )

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
                         column(width = 8,plotOutput('dunia_plot_final_2',height = 450)))
                )

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


# body
body = dashboardBody(tabItems(filterpane,dunia,jabar))

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
      geom_label(aes(label = paste0(round(total_cases/1000,1),'rb')),size=3) +
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
      geom_label(aes(label = round(total_tests_per_thousand,1)),size=3) +
      theme_minimal() +
      labs(title = 'Top 15 Negara dengan Jumlah Tes per 1000 Orang Terbanyak',
           subtitle = 'Negara yang melaporkan banyaknya tes',
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
      geom_label(aes(label = paste0(round(total_deaths/1000,1),'rb')),size=3) +
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
      filter(date == max(date)) %>% ungroup()
    
    data_new %>% 
      filter(total_tests>0) %>% 
      mutate(new_var = total_cases/total_tests) %>% 
      arrange(desc(new_var)) %>% head(15) %>% 
      ggplot(aes(x = reorder(location,new_var),y = new_var)) + 
      geom_col(color = 'orange',size=1.25,fill = 'yellow', alpha = .5) +
      geom_label(aes(label = paste0(round(new_var*100,1),'%')),size=3) +
      theme_minimal() +
      labs(title = 'Top 15 Negara dengan Ratio Cases per Test Terbanyak',
           subtitle = 'Negara yang melaporkan banyaknya tes',
           x = 'Negara',
           y = 'Ratio cases per test') +
      theme(axis.text.x = element_blank(),
            axis.text.y = element_text(size=10)) +
      coord_flip()
  })
  
  # plot dunia final 1
  output$dunia_plot_final_2 = renderPlot({
    data_new = 
      data_dunia %>%
      filter(continent %in% input$benua)
    
    negara = data_new %>% group_by(location) %>% summarise(total = max(total_cases)) %>% arrange(desc(total)) %>% 
      head(10)
    negara = negara$location
    
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
   
}


# ---------------------------------
# Run the application 
shinyApp(ui = ui, server = server)