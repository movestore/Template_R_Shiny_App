library("shiny")
library("move")

# to display messages to the user in the log file of the App in MoveApps
# one can use the function from the src/common/logger.R file:
# logger.fatal(), logger.error(), logger.warn(), logger.info(), logger.debug(), logger.trace()

shinyModuleUserInterface <- function(id, label) {
  # all IDs of UI functions need to be wrapped in ns()
  ns <- NS(id)
  # showcase to access a file ('auxiliary files') that is 
  # a) provided by the app-developer and 
  # b) can be overridden by the workflow user.
  fileName <- paste0(getAppFilePath("yourLocalFileSettingId"), "sample.txt")
 
   tagList(
    titlePanel("MoveApps R-Shiny SDK"),
    uiOutput(ns('uiIndivL')),
    plotOutput(ns("plot")),
    p(readChar(fileName, file.info(fileName)$size))
  )
}

# The parameter "data" is reserved for the data object passed on from the previous app
shinyModule <- function(input, output, session, data) {
  # all IDs of UI functions need to be wrapped in ns()
  ns <- session$ns
  current <- reactiveVal(data)
  
  ##--## example code - choose which individual to plot ##--## 
  output$uiIndivL <- renderUI({
    selectInput(ns("indivL"), "Select individual", choices=namesIndiv(data), selected=namesIndiv(data)[1])
  })
  output$plot <- renderPlot({
    plot(data[[input$indivL]])
  })
  ##--## end of example ##--##
  
  # data must be returned. Either the unmodified input data, or the modified data by the app
  return(reactive({ current() }))
}
