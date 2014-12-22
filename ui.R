require(shiny)
require(ggplot2)

##DO TABS WITH LOADING DATA ON LEFT SIDE

shinyUI(fluidPage(
  title = 'Movie Ratings Analytics',
  titlePanel("Favorite Directors"),  
  fluidRow(
    column(2,           
#            wellPanel(
#                
#            ),
           wellPanel(
             fileInput("imdbCSVfile", label = h5("IMDb CSV file:"), multiple = FALSE, 
                       accept = c('text/csv', 'text/comma-separated-values,text/plain','.csv')),
               sliderInput("yearSlider", label = h5("Year Range"), min = 1960, 
                         max = 2015, value = c(1960, 2015), format = "###0.#####")
           )
    ),
    column(6,
            plotOutput('topDirsPlot', height = "400px", clickId="topDirsPlotClick")           
    ),
    column(4,
           tableOutput('dirMoviesTable')         
    )
  ),
  hr()
  
  #       plotOutput('plotBigHM', width = "600px", height = "600px", clickId="myplotclick")  
#   plotOutput('plotBigHM',clickId="plotBigHMclick",hoverId = "plotBigHMhover",
#              width = "1400px", height = "480")  
  
)
)



