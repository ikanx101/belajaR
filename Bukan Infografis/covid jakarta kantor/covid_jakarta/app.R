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


# ---------------------------------
# ambil fungsi
rm(list=ls())
source('graph.R')

# ambil data
load('all files.rda')



# ---------------------------------
# ui

header = dashboardHeader(title = "COVID 19 vs TBC di Indonesia",titleWidth = 350)
sidebar = dashboardSidebar(width = 350,
                           sidebarMenu(
                               menuItem(tabName = 'covid_detail',
                                        text = 'Covid Pandemi in Indonesia')
                           ))

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
                                  dataTableOutput('table'))
                       )
                       )
    
body = dashboardBody(tabItems(covid_detail))

ui = dashboardPage(skin = "red",header,sidebar,body)


# ---------------------------------
# server
server <- function(input, output) {
    
    # tabel 1
    output$table <- renderDataTable(DT::datatable(data_covid_provinsi))
    
    # plot 1
    output$plot1 <- renderPlot({
        
    })
    
}

# ---------------------------------
# Run the application 
shinyApp(ui = ui, server = server)