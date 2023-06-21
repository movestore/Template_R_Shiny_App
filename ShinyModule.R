library("shiny")
library("move")

# to display messages to the user in the log file of the App in MoveApps
# one can use the function from the logger.R file:
# logger.fatal(), logger.error(), logger.warn(), logger.info(), logger.debug(), logger.trace()

shinyModuleUserInterface <- function(id, label) {
  # all IDs of UI functions need to be wrapped in ns()
  ns <- NS(id)
  # showcase to access a file ('auxiliary files') that is 
  # a) provided by the app-developer and 
  # b) can be overridden by the workflow user.
  fileName <- paste0(getAppFilePath("yourLocalFileSettingId"), "sample.txt")
  tagList(
    titlePanel("Plot of Track"),
    numericInput(inputId = ns("ind"), label = "Select one indivdual", value = 1),
    plotOutput(ns("plot")),
    p(readChar(fileName, file.info(fileName)$size))
  )
}

# The parameter "data" is reserved for the data object passed on from the previous app
shinyModule <- function(input, output, session, data) {
  # all IDs of UI functions need to be wrapped in ns()
  ns <- session$ns
  current <- reactiveVal(data)

  output$plot <- renderPlot({
    plot(data[[input$ind]])
  })
  # if data are not modified, the unmodified input data must be returned
  return(reactive({ current() }))
}
