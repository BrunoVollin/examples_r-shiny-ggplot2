library(readr)
library(dplyr)
library(ggplot2)
library(shiny)
library(shinydashboard)



projecao <- read_csv2(
    file = "https://raw.githubusercontent.com/jonates/opendata/master/projecao_IBGE_2018/projecao_IBGE_2018_atualizada06042020.csv",
    locale = locale(encoding = "ISO-8859-1")
)

populacao_regioes <- projecao %>%
    filter(Codigo_UF == 0, Codigo_Regiao != 0, Ano==2020, )



ui <- dashboardPage(
    dashboardHeader(),
    dashboardSidebar(),
    dashboardBody(
        box(
            title = "População residente por regiões do Brasil 2020",
            footer = "fonte: IBGE",
            status = "primary",
            plotOutput("populacaoregiao"),
        )
    )
)

server <- function(input, output, session){
    output$populacaoregiao <- renderPlot({
        ggplot(
            data = populacao_regioes,
            
        ) + 
            geom_col(
                aes(
                    x = Nome_Regiao,
                    y = Populacao_Total,
                    fill = Nome_Regiao,
                    
                )
            ) + 
            labs(
                x = "Regiões do Brasil",
                y = "População"
            ) +
            theme(
                legend.position = "bottom"
            ) + 
            scale_y_continuous(
                limits = c(0, 100000000),
                breaks = c(0, 20000000, 40000000, 60000000, 80000000, 100000000),
                labels = c("0", "20M", "40M", "60M", "80M","100M"),
            )
    })
    
}



shinyApp(ui = ui, server = server)

