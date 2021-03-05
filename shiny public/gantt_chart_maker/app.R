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
library(reshape2)
library(openxlsx)
library(readxl)
library(ggplot2)

rm(list=ls())

gant = data.frame(
    activity = c("Pembuatan proposal",
                 "Proposal submission",
                 "Pembuatan kuesioner",
                 "Finalisasi kuesioner",
                 "Fieldwork",
                 "Quality control",
                 "Data entry",
                 "Data preparation dan cleaning",
                 "Data processing",
                 "Pembuatan report",
                 "Report submission",
                 "Presentasi report"),
    state = c("Preparation",
              "Preparation",
              "Preparation",
              "Preparation",
              "Fieldwork",
              "Fieldwork",
              "Data Processing",
              "Data Processing",
              "Data Processing",
              "Reporting",
              "Reporting",
              "Reporting"),
    start = c("2021-03-04",
              "2021-03-06",
              "2021-03-08",
              "2021-03-10",
              "2021-03-14",
              "2021-03-20",
              "2021-04-23",
              "2021-04-29",
              "2021-05-06",
              "2021-05-09",
              "2021-05-15",
              "2021-05-22"),
    end = c("2021-03-06",
            "2021-03-07",
            "2021-03-10",
            "2021-03-13",
            "2021-04-23",
            "2021-04-24",
            "2021-04-28",
            "2021-05-05",
            "2021-05-10",
            "2021-05-14",
            "2021-05-21",
            "2021-05-25")
)

gant$activity = factor(gant$activity,levels = gant$activity)
gant$start = lubridate::date(gant$start)
gant$end = lubridate::date(gant$end)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Gantt Chart Maker v2.1"),
    
    fluidRow(column(width = 12,
                    h4("Readme:"),
                    h5("Silakan gunakan gantt chart maker ini. Untuk melakukan export terhadap grafik, isi terlebih dahulu dimensi (height dan width) dari grafik tersebut."),
                    h5("Last update 5 Maret 2021 10:00."))
             ),
    
    fluidRow(column(width = 4,
                    h4("Template Excel"),
                    h5("Silakan download template Ms. Excel berikut ini:"),
                    downloadButton("downloadData", "Download Excel"),
                    br(),
                    h4("Silakan upload kembali template excel tersebut ke web apps ini!"),
                    h5("Pastikan Anda tidak mengubah header dari file excel tersebut."),
                    fileInput('target_upload', 'Pilih file',
                              accept = c('xlsx')
                             ),
                    h4("Masukkan judul gantt chart Anda:"),
                    textInput("judul_gant","Masukkan judul"),
                    h4("Masukkan dimensi untuk export ke file png!"),
                    h5("Pastikan hanya angka yang Anda masukkan. Satuan yang digunakan adalah `inch`."),
                    h5("Kalau bingung, bisa dicoba tinggi = 6 dan lebar = 9"),
                    textInput("tinggi","Masukkan height:"),
                    textInput("lebar","Masukkan width:"),
                    downloadButton("downloadPlot", "Download PNG")
    ),
    column(width = 8,
           h3("Gantt Chart"),
           h4("Gantt Chart ini hanya menerima timeline dalam bentuk tanggal (tidak sampai detail jam atau detik)."),
           plotOutput("plot_1",height = 500),
           h5("Dibuat dengan R"),
           h5("Feel free to discuss"),
           h5("Created by: ikanx101.com")
    )
    ),
    fluidRow(dataTableOutput("tabel"))
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    data = reactive({
        gant
    })
    
    output$downloadData <- downloadHandler(
        filename = function() {
            paste0("Template.xlsx")
        },
        content = function(file) {
            openxlsx::write.xlsx(data(), file)
        }
    )
    
    data_upload <- reactive({
        inFile <- input$target_upload
        if (is.null(inFile))
            return(NULL)
        
        # baca data
        data <- 
            read_excel(inFile$datapath) %>% 
            janitor::clean_names() 
        
        data$activity = factor(data$activity,levels = data$activity)
        data$start = lubridate::date(data$start)
        data$end = lubridate::date(data$end)
        return(data)
        })
    
    output$tabel = renderDataTable({
        data_upload() 
    })
    
    output$plot_1 = renderPlot({
        gant_2 = 
            data_upload() %>% 
            melt(id.vars = c("activity","state")) %>% 
            rename(keterangan = variable,
                   date = value) 
        
        title_gant = input$judul_gant
        min = min(gant_2$date)
        max = max(gant_2$date)
        
        gant_2 %>% 
            ggplot(aes(date,activity,color = state)) +
            geom_line(aes(group = activity),size = 10) +
            theme_minimal() +
            labs(title = title_gant,
                 caption = "Visualized using R",
                 x = "Tanggal",
                 y = "Aktivitas",
                 color = "Keterangan") +
            theme(plot.title = element_text(face = "bold",size = 15),
                  legend.position = "bottom") +
            geom_vline(xintercept = min) +
            geom_vline(xintercept = max) +
            annotate("label",
                     x = min, 
                     y = max(length(unique(gant_2$activity))-1), 
                     label = paste0("Start:\n",min),
                     size = 2.5) +
            annotate("label",
                     x = max, 
                     y = 2, 
                     label = paste0("End:\n",max),
                     size = 2.5)
        
    })
    
    
    plotInput = function() {
        gant_2 = 
            data_upload() %>% 
            melt(id.vars = c("activity","state")) %>% 
            rename(keterangan = variable,
                   date = value) 
        
        title_gant = input$judul_gant
        min = min(gant_2$date)
        max = max(gant_2$date)
        
        gant_2 %>% 
            ggplot(aes(date,activity,color = state)) +
            geom_line(aes(group = activity),size = 10) +
            theme_minimal() +
            labs(title = title_gant,
                 caption = "Visualized using R",
                 x = "Tanggal",
                 y = "Aktivitas",
                 color = "Keterangan") +
            theme(plot.title = element_text(face = "bold",size = 15),
                  legend.position = "bottom") +
            geom_vline(xintercept = min) +
            geom_vline(xintercept = max) +
            annotate("label",
                     x = min, 
                     y = max(length(unique(gant_2$activity))-1), 
                     label = paste0("Start:\n",min),
                     size = 2.5) +
            annotate("label",
                     x = max, 
                     y = 2, 
                     label = paste0("End:\n",max),
                     size = 2.5)
    }
    
    output$downloadPlot = downloadHandler(
        filename = 'gantt chart.png',
        content = function(file) {
            device <- function(..., width, height) {
                grDevices::png(..., width = as.numeric(input$lebar), height = as.numeric(input$tinggi),
                               res = 600, units = "in")
            }
            ggsave(file, plot = plotInput(), device = device)
        })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
