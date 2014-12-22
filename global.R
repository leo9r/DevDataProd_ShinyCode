
trimString <- function (x) gsub("^\\s+|\\s+$", "", x)

cleanImdbRaw <- function(ratDF){
  names(ratDF)[names(ratDF)=="Title"] <- "title"
  names(ratDF)[names(ratDF)=="Directors"] <- "directors"
  names(ratDF)[9] <- "userRated"
  names(ratDF)[names(ratDF)=="IMDb.Rating"] <- "imdbRating"
  names(ratDF)[names(ratDF)=="Runtime..mins."] <- "runtime"
  names(ratDF)[names(ratDF)=="Year"] <- "year"
  names(ratDF)[names(ratDF)=="Genres"] <- "genres"
  names(ratDF)[names(ratDF)=="Num..Votes"] <- "numVotes"
  names(ratDF)[names(ratDF)=="Release.Date..month.day.year."] <- "releaseDate"
  
  ratDF <- ratDF[ratDF$Title.type == 'Feature Film',] # TV Series don't have directors
  ratDF$releaseDate <- as.Date(ratDF$releaseDate, "%Y-%m-%d")
  
  ratDF <- ratDF[,c('const','title','directors','userRated','imdbRating','runtime',
                  'year','genres','numVotes','releaseDate')]
  
  return(ratDF[complete.cases(ratDF),])
}

getUniqueDirs <- function(ratDF){
  dir.list <- strsplit(ratDF$directors, ",", fixed = TRUE)
  uniqueDirs <- data.frame(name = unique(trimString(unlist(dir.list))))
  
  uniqueDirs$dirMean <- sapply(uniqueDirs$name,function(dir){
    posDir <- grep(dir,ratDF$directors)
    mean(ratDF$userRated[posDir])
  })
  uniqueDirs$dirCount <- sapply(uniqueDirs$name,function(dir){
    length(grep(dir,ratDF$directors)) 
  })
 
  if(!is.numeric(uniqueDirs$dirCount)){
    return(head(uniqueDirs,0))
  }
  
  uniqueDirs$score <- (uniqueDirs$dirCount - mean(uniqueDirs$dirCount))
  dirCountSD <- sd(uniqueDirs$dirCount)
  if(!is.na(dirCountSD) &  dirCountSD != 0){
    uniqueDirs$score <- uniqueDirs$score/dirCountSD
  }  
  uniqueDirs$score <- ((abs(uniqueDirs$score))^0.6) * sign(uniqueDirs$score)
  uniqueDirs$score <- uniqueDirs$score + uniqueDirs$dirMean  
  return(uniqueDirs[order(-uniqueDirs$score),])
}
