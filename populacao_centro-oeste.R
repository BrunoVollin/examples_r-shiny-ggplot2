library(readr)
library(dplyr)
library(ggplot2)
library(shiny)
library(shinydashboard)



projecao <- read_csv2(
    file = "https://raw.githubusercontent.com/jonates/opendata/master/projecao_IBGE_2018/projecao_IBGE_2018_atualizada06042020.csv",
    locale = locale(encoding = "ISO-8859-1")
)

populacao_CO <- projecao %>%
    filter(Codigo_UF != 0, Nome_Regiao == "Centro-Oeste", Ano==2020,) %>%
    arrange(Populacao_Total) %>% #ordenando do maior para o menos
    mutate(Nome_UF = factor( x= Nome_UF, levels = Nome_UF))



ui <- dashboardPage(
    dashboardHeader(),
    dashboardSidebar(),
    dashboardBody(
        box(
            title = "População residente por UF, Centro Oeste, Brasil ",
            footer = "fonte: IBGE",
            status = "primary",
            plotOutput("centro_oeste"),
        )
    )
)

server <- function(input, output, session){
    output$centro_oeste <- renderPlot({
        ggplot(
            data = populacao_CO,
            
        ) + geom_col(
                aes(
                    x = Populacao_Total,
                    y = Nome_UF,
                    fill = Nome_UF,
                )
            ) + 
            labs(
                x = "Regiões do Brasil",
                y = "População"
            ) + 
            scale_x_continuous(
                limits = c(0, 8000000),
                breaks = c(0, 2000000, 4000000, 6000000, 8000000),
                labels = c("0", "2M", "4M", "6M", "8M"),
            )
    })
    
}



shinyApp(ui = ui, server = server)

