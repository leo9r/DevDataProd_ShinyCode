
require(grid) 
require(gridExtra)

ratsLeo <- read.csv("ratings_Leo.csv", stringsAsFactors=FALSE)
ratsLeo <- cleanImdbRaw(ratsLeo)
selectFirst <<- TRUE

shinyServer(function(input, output, session) {
  
  reactiveLoadData <- reactive({
    if(is.null(input$imdbCSVfile)){
      return(ratsLeo)
    }else{
      newRats <- cleanImdbRaw(read.csv(input$imdbCSVfile$datapath,stringsAsFactors=FALSE))
      return(newRats)
    }
  }) 
  
  reactiveSetYearRange <- reactive({  
    df <- reactiveLoadData()
    df <- df[df$year <= input$yearSlider[2] & df$year >= input$yearSlider[1],]    
    newlist <- list(rats=df, dirs=getUniqueDirs(df))
    selectFirst <<- TRUE   
    return(newlist)
  })
  
  reactiveSetNumberDirs <- reactive({   
    lt <- reactiveSetYearRange()
    lt$dirs <- head(lt$dirs,12)
    lt$dirs$nameF <- factor(lt$dirs$name, levels=rev(lt$dirs$name))   
    return(lt)
  }) 
  
  reactiveSelectDir <- reactive({ 
   
    lt <- reactiveSetNumberDirs()
    
    if(nrow(lt$dirs) > 0){
      
      if(is.null(input$topDirsPlotClick$y) | selectFirst){
        lt$dirs$selected  <- FALSE
        lt$dirs$selected[1] <- TRUE
        selectFirst <<- FALSE 
      }else{
        lt$dirs$selected <- FALSE      
        lt$dirs$selected[1 + as.integer(nrow(lt$dirs) - 
                                      (input$topDirsPlotClick$y * 
                                        nrow(lt$dirs) / 0.97))] <- TRUE      
      }
    }    
    return(lt)
  }) 
  
  output$dirMoviesTable <- renderTable({
    lt <- reactiveSelectDir()
    
    if(nrow(lt$dirs) > 0){
      
    selectedDirName <- lt$dirs$name[lt$dirs$selected]
    rat <- lt$rats[grep(selectedDirName,lt$rats$directors),c('title','year','userRated','imdbRating')]
    rat[order(-rat$year),]
    }
  },include.rownames=FALSE) 
  
  output$topDirsPlot <- renderPlot({
    lt <- reactiveSelectDir()
    
    if(nrow(lt$dirs) > 0){
    
      topDirs <- lt$dirs    
      g.names<-ggplot(data = topDirs,aes(x=1,y=nameF)) + 
        geom_text(aes(label=name,colour=selected))+
        ggtitle("Top Directors") + 
        ylab(NULL) + # ggtitle(NULL) +   
        theme(axis.title=element_blank(),        
              axis.text=element_blank(),
              axis.ticks=element_blank(),
              panel.grid=element_blank(),
              panel.background=element_blank(),
              legend.position="none",
              plot.margin = unit(c(1,0,1,0), "mm"))
      
      g.means <- ggplot(data = topDirs, aes(x = nameF, y = dirMean)) +
        geom_bar(aes(fill=selected), stat = "identity",position = "identity") + 
        geom_text(aes(label=format(round(dirMean, 2), nsmall = 2)),hjust=-0.3) +
        ggtitle("User Rating Avg.") +  
  #       ggtitle(NULL) + 
        theme(axis.title = element_blank(),         
              axis.text = element_blank(), 
              axis.ticks = element_blank(),
              panel.grid=element_blank(),
              panel.background=element_blank(),
              legend.position="none",
              plot.margin = unit(c(1,0,1,0), "mm")) +
        scale_y_reverse(expand=c(0,0)) + coord_flip()
      
      g.counts <- ggplot(data = topDirs, aes(x = nameF, y = dirCount)) +  
        geom_bar(aes(fill=selected), stat = "identity") + 
        ggtitle("Number of Rated Movies") + 
        xlab(NULL) + #ggtitle(NULL) + 
        geom_text(aes(label=dirCount),hjust=2) +
        theme(axis.title = element_blank(),         
              axis.text = element_blank(), 
              axis.ticks = element_blank(),
              panel.grid=element_blank(),
              panel.background=element_blank(),
              legend.position="none",
              plot.margin = unit(c(1,0,1,0), "mm")) +
        scale_y_discrete(expand=c(0,0)) + coord_flip()
      
      grid.arrange(g.means,g.names,g.counts,ncol=3,widths=c(1,1,2.2))
    }
  })


#   
#   output$dlrCITY <- renderText({
#     visData <- testing1310[testing1310$dlrNBR == input$selectedDLR,]
#     paste('-------->',visData[1,c('dlrCITY')]) 
#   })
#   output$dlrSTATE <- renderText({
#     visData <- testing1310[testing1310$dlrNBR == input$selectedDLR,]
#     paste('-------->',visData[1,c('dlrSTATE')]) 
#   })
#   
#   output$hoverHM <- renderText({
#     #     clickedX <- input$plotBigHMclick$x
#     if(!is.null(input$plotBigHMhover)){
#       paste(sortedDLRS[as.integer((input$plotBigHMhover$x - 0.0263)*176)+1],
#             sortedSN[as.integer((input$plotBigHMhover$y - 0.0653)/((1.0022 - 0.0653)/48))+1])
#       #       input$plotBigHMhover$y
#     }else{''}
#     
#   })
  
#     observe({
#       print(input$imdbCSVfile)
#       
# #       print(input$topDirsPlotClick$y)
# #       print(1 + as.integer(nrow(topDirs1) - (input$topDirsPlotClick$y * nrow(topDirs1) / 0.97)))
#              })
  
  
})

