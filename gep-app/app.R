library(shiny)
library(shinythemes)
source("geodb_utils.R")

getSQLiteFile()
con <- dbConnect(SQLite(), "GEOmetadb.sqlite")

server <- function(input, output, session){
    
    gse.list <- reactive({ list.gse.by.gpl(con, input$gpl) })
    
    output$selectgseUI <- renderUI({
      selectInput('gse', 'Select GEO Series', gse.list(),
                  multiple = TRUE, selectize = TRUE)
    })
    
    output$tabs <- renderUI({

        Tabs <- lapply(input$gse, 
            function(nm) {
                sample.list <- list.gsm.by.gse(con, nm)
                Samples <- lapply(sample.list,
                    function(sample) {
                        condition <- sprintf('input.%s', sample)
                        p(checkboxInput(sample, sample),
                          conditionalPanel(condition=condition,
                          wellPanel(
                            p(strong('Status'), gsm.status(con, sample)),
                            p(strong('Title'), gsm.title(con, sample)),
                            p(strong('Sample type'), gsm.type(con, sample)),
                            p(strong('Source name'), gsm.source(con, sample)),
                            p(strong('Organism'), gsm.organism(con, sample)),
                            strong('Characteristics'), 
                            tags$pre(gsm.characteristics(con, sample)),
                            p(strong('Treatment protocol'), 
                                gsm.treatment_protocol(con, sample)),
                            p(strong('Extracted molecule'), 
                                gsm.molecule(con, sample)),
                            p(strong('Extraction protocol'),
                                gsm.extract_protocol(con, sample)),
                            p(strong('Label'), gsm.label(con, sample)),
                            p(strong('Label protocol'), 
                                gsm.label_protocol(con, sample)),
                            p(strong('Hybridization protocol'), 
                                gsm.hyb_protocol(con, sample)),
                            p(strong('Description'), 
                                gsm.description(con, sample)),
                            p(strong('Data processing'), 
                                gsm.data_processing(con, sample))
                            )
                            )           
                        )
                    }
                            )
                        tabPanel( title=nm,
                        p(strong('Status'), gse.status(con, nm)),
                        p(strong('Title'), gse.title(con, nm)),
                        p(strong('Organism'), gse.organism(con, nm)),
                        p(strong('Experiment type'), gse.type(con, nm)),
                        p(strong('Summary'), gse.summary(con, nm)),
                        p(strong('Overall Design'), gse.overall.design(con, nm)),
                        h3('Samples'),
                        do.call(p, Samples)
                        )
                       }
                       )

        do.call(tabsetPanel, Tabs)
    })
    
}

ui <- fluidPage(theme = shinytheme("cosmo"),      
    titlePanel("Gene Expression Pipeline"),
    
    sidebarLayout(
        
        sidebarPanel(
            selectInput('gpl', 'Search for datasets by Platform', list.all.gpl(con),
                        multiple = TRUE, selectize = TRUE),
            textInput('keyword','Search for datasets by Keyword'),
            hr(),
            htmlOutput('selectgseUI')
        ),

        mainPanel(
           htmlOutput('tabs') 
        ),
    )
)


shinyApp(ui = ui, server = server)
