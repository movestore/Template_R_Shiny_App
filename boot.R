result <- shiny::runApp(appDir = 'co-pilot-sdk.R', port = 3838)
# provide the exit code of the R function to the caller
quit(save="no",status=result,runLast=FALSE)