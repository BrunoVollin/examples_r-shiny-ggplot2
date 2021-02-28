library(readr)
library(dplyr)
library(ggplot2)
library(shiny)
library(shinydashboard)



projecao <- read_csv2(
    file = "https://raw.githubusercontent.com/jonates/opendata/master/projecao_IBGE_2018/projecao_IBGE_2018_atualizada06042020.csv",
    locale = locale(encoding = "ISO-8859-1")
)

EVN_sul <- projecao %>% filter(Nome_Regiao == "Sul", Codigo_UF != 0)


ui <- dashboardPage(
    dashboardHeader(),
    dashboardSidebar(),
    dashboardBody(
        box(
            title = "Expectativa de vida, sul do Brasil, 2000 a 2060 ",
            footer = "fonte: IBGE",
            status = "primary",
            plotOutput("EVN")
        )
    )
)

server <- function(input, output, session){
    output$EVN <- renderPlot({
        ggplot(
            data = EVN_sul,
        ) + geom_line( #tipo do grafico
                aes(
                    x = Ano,
                    y = EVN,
                    color = Nome_UF
                )
            ) + 
            labs(
                x = "Ano",
                y = "Expectativa de vida",
                color = "UF"
            ) + 
            theme(
               legend.position = "bottom" 
            )
    })
    
}



shinyApp(ui, server)

