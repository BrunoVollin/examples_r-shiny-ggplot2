

library(shinydashboard)


ui <- dashboardPage(
    dashboardHeader(title = "Aprendendo Shiny"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Material de Estudo", tabName = "tab0", icon = icon("dashboard")),
            menuItem("Histograma", tabName = "tab1", icon = icon("dashboard")),
            menuItem("Shiny Text", tabName = "tab2", icon = icon("th")),
            menuItem("bom dia", tabName = "tab3", icon = icon("calendar")),
            menuItem("Gráficos de	dispersão", tabName = "tab4", icon = icon("calendar"))
        )
    ),
    dashboardBody(
        tabItems(
            # TAB 0
            tabItem(tabName = "tab0",
                    h1("Material de Estudo"),
                    
                    h4("Visualização de dados, gráficos em R:"),
                    a("http://darwin.di.uminho.pt/cursoAnaliseDados/sessao3-apontamentos.pdf"),
                    
                    h4("Shiny Rstudio"),
                    a("https://shiny.rstudio.com/"),
                    
                    h4("Visualização de dados, gráficos em R:"),
                    a("http://darwin.di.uminho.pt/cursoAnaliseDados/sessao3-apontamentos.pdf"),
            ),
                    
            # TAB 1 
            tabItem(tabName = "tab1",
                    fluidRow(
                        box(plotOutput("tab1", height = 250)),
                        
                        box(
                            title = "Controls",
                            sliderInput("slider", "Number of observations:", 1, 100, 50)
                        )
                    )
            ),
            
            # TAB 2
            tabItem(tabName = "tab2",
                    titlePanel("Shiny Text"),
                
                    sidebarLayout(
                        sidebarPanel(
                            selectInput(inputId = "dataset",
                                        label = "Choose a dataset:",
                                        choices = c("rock", "pressure", "cars")),
                            
                        ),
                        
                        mainPanel(
                            verbatimTextOutput("tab2"),
                            
                        )
                    )
            ),
            # TAB 3
            tabItem(tabName = "tab3",
                    titlePanel("Reactivity"),
                    
                    sidebarLayout(
                        
                        sidebarPanel(
                            
                            
                            selectInput(inputId = "dataset",
                                        label = "Choose a dataset:",
                                        choices = c("rock", "pressure", "cars")),
                            
                            numericInput(inputId = "obs",
                                         label = "Number of observations to view:",
                                         value = 10)
                            
                        ),
                        
                        mainPanel(
                            tableOutput("tab3")
                            
                        )
                    )
            ),
            
            # TAB 4
            tabItem(tabName = "tab4",
                    fluidRow(
                        #box(plotOutput("tab4", height = 250)),
                        
                        box( plotOutput("tab4", height = 1),
                            title = "Tente Clicar no Grafico",
                            plotOutput("plot1", click = "plot_click"),
                            verbatimTextOutput("info")
                        )
                    )
            )
        )
    )
)

server <- function(input, output) {
    set.seed(122)
    histdata <- rnorm(500)
    
    #OUTPUT 1
    output$tab1 <- renderPlot({
        data <- histdata[seq_len(input$slider)]
        hist(data)
        
    })
    
    #OUTPUT 2
    output$tab2 <- renderTable({
        datasetInput <- reactive({
            switch(input$dataset,
                   "rock" = rock,
                   "pressure" = pressure,
                   "cars" = cars)
            
        })
        
        output$tab2 <- renderPrint({
            dataset <- datasetInput()
            summary(dataset)
            
        })
    
    })
    
    #OUTPUT 3
    output$tab3 <- renderTable({
        datasetInput <- reactive({
            switch(input$dataset,
                   "rock" = rock,
                   "pressure" = pressure,
                   "cars" = cars)
        })
        
        
        output$tab3 <- renderTable({
            head(datasetInput(), n = input$obs)
        })
        
    })
    
  
        
    #OUTPUT 4 
    output$tab4 <- renderPlot({
        output$plot1 <- renderPlot({
            plot(mtcars$wt, mtcars$mpg)
        })
        
        output$info <- renderText({
            paste0("x=", input$plot_click$x, "\ny=", input$plot_click$y)
        })
    })
        
 
}


shinyApp(ui = ui, server = server)
