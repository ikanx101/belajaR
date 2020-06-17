#
# Perbandingan TB dengan COVID19
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
library(deSolve)
# library(shiny)

# ---------------------------------
# ambil fungsi
rm(list=ls())
today = Sys.time()
today = as.character(today)

# untuk spread R0
dise = c('Covid 19','TBC')
r0_min = c(1.4,1.19)
r0_max = c(4,3.33)

spread = data.frame(dise,r0_min,r0_max)

# ambil data
load('all files.rda')
provinsi = unique(data_covid_provinsi$province)

# ---------------------------------
# ui

header = dashboardHeader(title = "COVID 19 vs TBC di Indonesia",
                         titleWidth = 350)
sidebar = dashboardSidebar(width = 350,
                           sidebarMenu(
                               menuItem(tabName = 'filterpane',
                                        text = 'Read Me'),
                               menuItem(tabName = 'covid_detail',
                                        text = 'Covid Pandemi in Indonesia - Provinsi'),
                               menuItem(tabName = 'tbc',
                                        text = 'Data TBC di Indonesia')
                           )
                           )

filterpane = tabItem(tabName = 'filterpane',
                     fluidRow(
                         column(width = 12,
                                h1('READ ME'),
                                h2(paste0('Update data per: ',today))
                                )
                     ),
                     br(),
                     fluidRow(
                         column(width = 12,
                                h3('Silakan pilih filter berikut ini sesuai dengan kebutuhan'),
                                checkboxGroupInput('prop','Provinsi di Indonesia',
                                                   sort(provinsi),selected = provinsi))
                     )
                     )
    
covid_detail = tabItem(tabName = 'covid_detail',
                       fluidRow(
                           column(width = 12,
                                  h1('COVID-19 pandemic in Indonesia'),
                                  h4('The COVID-19 pandemic in Indonesia is part of the ongoing worldwide pandemic of coronavirus disease 2019 (COVID-19) caused by severe acute respiratory syndrome coronavirus 2 (SARS-CoV-2). It was confirmed to have spread to Indonesia on 2 March 2020, after a dance instructor and her mother tested positive for the virus. Both were infected from a Japanese national.'),
                                  h4('By 9 April, the pandemic had spread to all 34 provinces in the country as Gorontalo confirmed its first case, with Jakarta, East Java, and South Sulawesi being the worst-hit. The largest increase of new cases in a single day occurred on 10 June, when 1,241 cases were announced. On 14 June, for the first time ever, there were more than 750 recoveries recorded and 18,000 samples tested just within a span of 24 hours.'),
                                  h4('As of 15 June, Indonesia has reported 39,294 cases, the second highest in Southeast Asia, behind Singapore. In terms of death numbers, Indonesia ranks sixth in Asia with 2,198 deaths. Review of data, however, indicated that the number of deaths may be much higher than what has been reported as those who died with acute COVID-19 symptoms but had not been confirmed or tested were not counted in the official death figure.'),
                                  h4('Indonesia has conducted 523,063 tests against its 273 million population so far, or around 1,915 tests per million, making it one of the worst testing rates in the world. As a comparison, it is lower than Suriname which has only around 586 thousand population, yet has conducted 1,987 tests per million.'),
                                  h5('source: wikipedia')
                                  )
                       ),
                       fluidRow(
                           column(width = 12,
                                  h2('Data Detail Sebaran COVID-19 per Provinsi'),
                                  h4('Update tanggal 15 Juni 2020, pukul 23.59'),
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

tbc = tabItem(tabName = 'tbc',
                    fluidRow(
                        column(width = 12,
                               h1('Informasi Terkait Tuberculosis'),
                               h4('Various sources')
                               )
                    ),
                    fluidRow(
                        column(width = 4,
                               plotOutput('plot4',height = 350))
                    )
                    )
    
body = dashboardBody(tabItems(filterpane,covid_detail,tbc))

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
            geom_point(color = 'black',aes(size = confirmed)) +
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
            ggplot(aes(x = province,
                       y = value)) +
            geom_col(color = 'black',fill = 'blue', alpha = .25) + 
            geom_label(aes(label = value),size=3) +
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
    
    
    # plot 4
    output$plot4 <- renderPlot({
       spread %>% 
            ggplot(aes(x = dise)) +
            geom_errorbar(aes(ymin = r0_min,
                              ymax = r0_max),
                          size=1,
                          width=.1) +
            labs(title = 'Perbandingan R0\nCovid 19 dan TBC') +
            theme_pubclean() +
            theme(axis.title = element_blank(),
                  axis.text = element_text(size=15)) +
            coord_flip()
    })
}

# ---------------------------------
# Run the application 
shinyApp(ui = ui, server = server)