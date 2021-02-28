#install.packages("geobr")
library(readr)
library(dplyr)
library(ggplot2)
library(shiny)
library(shinydashboard)
library(geobr)



projecao <-
    read_csv2(file = "https://raw.githubusercontent.com/jonates/opendata/master/projecao_IBGE_2018/projecao_IBGE_2018_atualizada06042020.csv",
              locale = locale(encoding = "ISO-8859-1"))

populacao_UF <- projecao %>%
    filter(Codigo_Regiao != 0, Codigo_UF != 0, Ano == 2020) %>% #dplyr
    select(Codigo_UF, Populacao_Total)

#shapefile do geobr
shape_UF <- geobr::read_state()

#nomes das variaveis
names(populacao_UF)
names(shape_UF)

#juntando as bd
mapa_UF <-
    dplyr::left_join(x = shape_UF,
                     y = populacao_UF,
                     by = c("code_state" = "Codigo_UF"))



ui <- dashboardPage(dashboardHeader(),
                    dashboardSidebar(),
                    dashboardBody(
                        box(
                            title = "População residente por UF, Brasil ",
                            footer = "fonte: IBGE",
                            status = "primary",
                            plotOutput("populacaoUF")
                        )
                    ))

server <- function(input, output, session) {
    output$populacaoUF <- renderPlot({
        ggplot() + geom_sf(data = mapa_UF,
                           aes(fill = Populacao_Total))
    })
    
}



shinyApp(ui = ui, server = server)
