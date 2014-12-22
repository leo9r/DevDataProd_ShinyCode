require(shiny)
require(ggplot2)

##DO TABS WITH LOADING DATA ON LEFT SIDE

shinyUI(fluidPage(
  title = 'Movie Ratings Analytics',
  titlePanel("Favorite Directors"),
  h4("Please be patient, wait for a barplot and a table to appear in the middle and right columns.
      The page takes sometime to render when the ShinyApps server is under heavy use."),
  fluidRow(
    column(2,           
           h5("(1) You can play with the automatically loaded example data (from my IMDb profile) 
              or load your own CSV ratings from IMDb"),
           wellPanel(
             fileInput("imdbCSVfile", label = h6("IMDb CSV file:"), multiple = FALSE, 
                       accept = c('text/csv', 'text/comma-separated-values,text/plain','.csv'))),
           wellPanel(
               sliderInput("yearSlider", label = h5("Year Range"), min = 1960, 
                         max = 2015, value = c(1960, 2015), format = "###0.#####")
           )
    ),
    column(6,
           h5("(2) Check the list of your Favorite Directors. Click to get movies details"),
            plotOutput('topDirsPlot', height = "400px", clickId="topDirsPlotClick")           
    ),
    column(4,
           h5("(3) Click on a director to get a detailed list of his/her movies"),
           tableOutput('dirMoviesTable')         
    )
  ),
  hr()
  
  #       plotOutput('plotBigHM', width = "600px", height = "600px", clickId="myplotclick")  
#   plotOutput('plotBigHM',clickId="plotBigHMclick",hoverId = "plotBigHMhover",
#              width = "1400px", height = "480")  
  
)
)



