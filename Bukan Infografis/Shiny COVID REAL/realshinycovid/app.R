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
# library(shiny)


# ---------------------------------
# ambil data dan semua fungsi
rm(list=ls())
load('all files.rda')

# tanggal
tanggal = Sys.Date()
tanggal = as.character(tanggal)

# video update youtube masuk ke sini yah
url = 'https://www.youtube.com/watch?v=WaF_YcKMF6A'
url = gsub('https://www.youtube.com/watch?v=','',url,fixed = T)
url


# ---------------------------------
# USER INTERFACE

# header
header = dashboardHeader(title = "COVID 19 Indonesia Viz",
                         titleWidth = 350)

#sidebar menu
sidebar = dashboardSidebar(width = 350,
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
                                h3('Bagi yang kangen dengan Pak Yuri, silakan tonton dulu press conference hari ini:'),
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
                         )
                )

# body
body = dashboardBody(tabItems(filterpane,dunia))

# ui all
ui = dashboardPage(skin = "red",header,sidebar,body)




server <- function(input, output, session) {
}


# ---------------------------------
# Run the application 
shinyApp(ui = ui, server = server)