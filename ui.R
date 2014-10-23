shinyUI(pageWithSidebar(
  headerPanel("Registred vehicles in Barcelona by district (2009-2011)"),
  sidebarPanel(
    ##sliderInput('year', 'Year',value = 2010, min = 2009, max = 2011, step = 1,),
    selectInput('dte','District',c('All',sort(unique(vehicles$dte)))),
    radioButtons("display", "Totals/Percentages:",
                 c("Totals" = "totals", "Percentages" = "percentages"), inline = TRUE)
  ),
  mainPanel(
    plotOutput('thePlot'),
    tableOutput('barris_list')
  )
))
