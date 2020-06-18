#
# Data COVID19 Indonesia
# ikanx101.github.io
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
#library(shiny)

# ---------------------------------
# ambil fungsi
# source('data wikipedia.R')
# source('jabar clean.R')
# source('jakarta clean.R')
# source('dunia dalam data.R')
rm(list=ls())
today = Sys.Date() - 1
today = as.character(today)

# ambil data
load('all files.rda')
provinsi = unique(data_covid_provinsi$province)
kota_jabar = unique(data_jabar$nama_kab)
kecamatan_jkt = unique(data_jakarta$kecamatan)

# ---------------------------------
# ui

header = dashboardHeader(title = "COVID 19 di Indonesia",
                         titleWidth = 350)
sidebar = dashboardSidebar(width = 350,
                           sidebarMenu(
                               menuItem(tabName = 'filterpane',
                                        text = 'Read Me'),
                               menuItem(tabName = 'covid_detail',
                                        text = 'Covid Pandemi in Indonesia - Provinsi'),
                               menuItem(tabName = 'jabar',
                                        text = 'Data Covid 19 Jawa Barat'),
                               menuItem(tabName = 'jkt48',
                                        text = 'Data Covid 19 DKI Jakarta'),
                               menuItem(tabName = 'dunia',
                                        text = 'Dunia dalam Covid 19')
                           )
                           )

filterpane = tabItem(tabName = 'filterpane',
                     fluidRow(
                         column(width = 12,
                                h1('READ ME'),
                                h3('Dashboard ini akan selalu mengupdate dataset dari sumber-sumber resmi pemerintah pusat / provinsi setiap kali admin melakukan refresh ke server. Sebagaimana kita tahu, Pak Yuri akan update di sore hari jadi data akan saya refresh jam 17:00.'),
                                h5('For further assistance, please let me know.'),
                                h5(paste0('Update data per: ',today, 'pukul 17.00'))
                                )
                     )
                     )
    
covid_detail = tabItem(tabName = 'covid_detail',
                       fluidRow(
                           column(width = 10,
                                  h1('COVID-19 pandemic in Indonesia'),
                                  h4('The COVID-19 pandemic in Indonesia is part of the ongoing worldwide pandemic of coronavirus disease 2019 (COVID-19) caused by severe acute respiratory syndrome coronavirus 2 (SARS-CoV-2). It was confirmed to have spread to Indonesia on 2 March 2020, after a dance instructor and her mother tested positive for the virus. Both were infected from a Japanese national.'),
                                  h4('By 9 April, the pandemic had spread to all 34 provinces in the country as Gorontalo confirmed its first case, with Jakarta, East Java, and South Sulawesi being the worst-hit. The largest increase of new cases in a single day occurred on 10 June, when 1,241 cases were announced. On 14 June, for the first time ever, there were more than 750 recoveries recorded and 18,000 samples tested just within a span of 24 hours.'),
                                  h4('As of 15 June, Indonesia has reported 39,294 cases, the second highest in Southeast Asia, behind Singapore. In terms of death numbers, Indonesia ranks sixth in Asia with 2,198 deaths. Review of data, however, indicated that the number of deaths may be much higher than what has been reported as those who died with acute COVID-19 symptoms but had not been confirmed or tested were not counted in the official death figure.'),
                                  h4('Indonesia has conducted 523,063 tests against its 273 million population so far, or around 1,915 tests per million, making it one of the worst testing rates in the world. As a comparison, it is lower than Suriname which has only around 586 thousand population, yet has conducted 1,987 tests per million.'),
                                  h5('source: wikipedia')
                                  ),
                           column(width = 2,
                                  h3('Silakan pilih filter berikut ini sesuai dengan kebutuhan'),
                                  checkboxGroupInput('prop','Provinsi di Indonesia',
                                                     sort(provinsi),selected = provinsi))
                       ),
                       fluidRow(
                           column(width = 12,
                                  h2('Data Detail Sebaran COVID-19 per Provinsi'),
                                  h4(paste0('Update data per: ',today)),
                                  DT::dataTableOutput("tabel1"))
                       ),
                       br(),
                       fluidRow(
                           column(width = 5,
                                  plotOutput('plot1',height = 550)),
                           column(width = 7,
                                  plotOutput('plot2',height = 550))
                       ),
                       br(),
                       fluidRow(
                           column(width = 12,
                                  h2('Detail Confirmed Cases'),
                                  plotlyOutput('plot3',height = 600))
                       )
                       )

jabar = tabItem(tabName = 'jabar',
                    fluidRow(
                        column(width = 12,
                               h1('Informasi Covid di Jawa Barat'),
                               h4('Data diambil dari website: https://pikobar.jabarprov.go.id/table-case'),
                               h4('Silakan pilih nama kabupaten / kota yang diinginkan untuk mengubah grafik yang ada.'),
                               h5(paste0('Update data per: ',today))
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
                               plotOutput('plot4',height = 400),
                               br(),
                               plotOutput('plot5',height = 300))
                    ),
                    br(),
                fluidRow(
                    column(width = 12,
                           h1('Grafik Total Akumulasi Provinsi Jawa Barat'),
                           h5('Catatan: smooth trendline dibuat dengan metode loess'))
                ),
                fluidRow(
                    column(width = 6,
                           plotOutput('plot_tambah1',height = 400)),
                    column(width = 6,
                           plotOutput('plot_tambah2',height = 400))
                )
                    )

jakarta = tabItem(tabName = 'jkt48',
                  fluidRow(
                      column(width = 12,
                             h1('Informasi Covid di DKI Jakarta'),
                             h4('Data diambil dari website: https://data.jakarta.go.id/dataset/data-odp-pdp-dan-positif-covid-19-dki-jakarta-per-kecamatan'),
                             h4('Data dari open data Jakarta hanay sampai tanggal 2 Juni 2020.'),
                             h5('Catatan: smooth trendline dibuat dengan metode loess'),
                             h5(paste0('Update data per: ',today))
                             )
                  ),
                  fluidRow(
                      column(width = 6,
                             plotOutput('plot6',height = 400)),
                      column(width = 6,
                             plotOutput('plot7',height = 400))
                  )
                  )


body = dashboardBody(tabItems(filterpane,covid_detail,jabar,jakarta,dunia))

ui = dashboardPage(skin = "red",header,sidebar,body)


# ---------------------------------
# server
server <- function(input, output) {
    
    # tabel 1
    output$tabel1 <- DT::renderDataTable({
        data_covid_provinsi %>% 
            filter(provinsi %in% input$prop)
    })
    
    # plot 1
    output$plot1 <- renderPlot({
        data_covid_provinsi = 
            data_covid_provinsi %>% 
            filter(provinsi %in% input$prop)
        
        mean1 = mean(data_covid_provinsi$fatality_rate)
        mean2 = mean(data_covid_provinsi$recovery_rate)
        
        data_covid_provinsi %>%
            ggplot(aes(x=recovery_rate,
                       y=fatality_rate)) +
            geom_point(aes(size = confirmed,color = confirmed)) +
            geom_text_repel(aes(label = province,alpha = confirmed)) +
            theme_pubclean() +
            labs(x = 'Recovery Rate',
                 y = 'Fatality Rate',
                 title = 'Recovery vs Fatality in Indonesia',
                 subtitle = 'Point size indicate confirmed cases') +
            geom_vline(xintercept = mean2, color = 'red') +
            geom_hline(yintercept = mean1, color = 'red') +
            theme(legend.position = 'none')
    })
    
    # plot 2
    output$plot2 <- renderPlot({
        data_covid_provinsi = 
            data_covid_provinsi %>% 
            filter(provinsi %in% input$prop)
        
        data_covid_provinsi %>% 
            select(province,confirmed,cases_per_mil_pop) %>% 
            reshape2::melt(id.vars = 'province') %>% 
            mutate(variable = ifelse(variable == 'confirmed',
                                     'Confirmed Cases',
                                     'Cases per Million Population')) %>%
            ggplot(aes(x = reorder(province,-value),
                       y = value)) +
            geom_col(color = 'black',fill = 'darkred', alpha = .25) + 
            geom_label(aes(label = value),size=2.5) +
            facet_wrap(~variable,nrow = 2,scales = 'free_y') +
            theme_pubclean() +
            theme(axis.text.x = element_text(angle=90),
                  axis.text.y = element_blank()) +
            theme(strip.background = element_rect(colour="black", 
                                                  fill="white",
                                                  size=1.5, 
                                                  linetype="solid"),
                  axis.title = element_blank(),
                  axis.ticks = element_blank())
    })
    
    # plot 3
    output$plot3 <- renderPlotly({
        data_covid_provinsi = 
            data_covid_provinsi %>% 
            filter(provinsi %in% input$prop)
        
        new = 
            data_covid_provinsi %>% 
            select(province,deaths,active,recovered) %>% 
            reshape2::melt(id.vars = 'province') %>% 
            mutate(text = paste(province,variable,'=',value))
        
        chart = 
        new %>% 
            ggplot(aes(x = reorder(province,-value),
                       y = value)) +
            geom_col(aes(fill = variable,text = text)) +
            theme(axis.text.x = element_text(angle=90)) +
            labs(x = 'Provinsi',
                 y = 'Cases')
        
        ggplotly(chart, tooltip = "text")
    })
    
    #plot 4
    output$plot4 = renderPlot({
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
    output$plot5 <- renderPlot({
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
    
    # plot 6
    output$plot6 <- renderPlot({
        data_new =
            data_jakarta %>% 
            mutate(tanggal = as.Date(tanggal)) %>% 
            group_by(tanggal) %>% 
            summarise(odp = sum(odp),
                      pdp = sum(pdp),
                      positif = sum(positif),
                      meninggal = sum(meninggal),
                      sembuh = sum(sembuh))
        
        chart_1 = 
        data_new %>% 
            ggplot(aes(x = tanggal,
                       y = odp)) +
            geom_smooth(method = 'loess',color = 'gray',fill = 'yellow') +
            geom_line(color = 'steelblue',size=1.25) +
            theme_pubclean() +
            labs(title = 'Total Akumulasi ODP di DKI Jakarta') +
            theme(axis.title = element_blank()) 
        
        chart_2 = 
            data_new %>% 
            ggplot(aes(x = tanggal,
                       y = pdp)) +
            geom_smooth(method = 'loess',color = 'gray',fill = 'yellow') +
            geom_line(color = 'darkred',size=1.25) +
            theme_pubclean() +
            labs(title = 'Total Akumulasi PDP di DKI Jakarta') +
            theme(axis.title = element_blank()) 
        
        ggarrange(chart_1,chart_2,nrow=2)    
    })
    
    # plot 7
    output$plot7 <- renderPlot({
        data_new =
            data_jakarta %>% 
            mutate(tanggal = as.Date(tanggal)) %>% 
            group_by(tanggal) %>% 
            summarise(odp = sum(odp),
                      pdp = sum(pdp),
                      positif = sum(positif),
                      meninggal = sum(meninggal),
                      sembuh = sum(sembuh))
        
        chart_1 = 
            data_new %>% 
            ggplot(aes(x = tanggal,
                       y = positif)) +
            geom_smooth(method = 'loess',color = 'gray',fill = 'yellow') +
            geom_line(color = 'green',size=1.25) +
            theme_pubclean() +
            labs(title = 'Total Akumulasi Positif di DKI Jakarta') +
            theme(axis.title = element_blank())
        
        chart_2 = 
            data_new %>% 
            ggplot(aes(x = tanggal,
                       y = meninggal)) +
            geom_smooth(method = 'loess',color = 'gray',fill = 'yellow') +
            geom_line(color = 'red',size=1.25) +
            theme_pubclean() +
            labs(title = 'Total Akumulasi Korban Meninggal di DKI Jakarta') +
            theme(axis.title = element_blank())
        
        ggarrange(chart_1,chart_2,nrow=2)    
    })
    
    # plot tambah1
    output$plot_tambah1 <- renderPlot({
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
    
    # plot tambah2
    output$plot_tambah2 <- renderPlot({
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