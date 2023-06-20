library("shiny")
library("move")

# to display messages to the user in the log file of the App in MoveApps
# one can use the function from the logger.R file:
# logger.info(). Available levels are error(), warn(), info(), debug(), trace()

shinyModuleUserInterface <- function(id, label) {
  ns <- NS(id) ## all IDs of UI functions need to be wrapped in ns()
  tagList(
    titlePanel("Plot of Track"),
    numericInput(inputId = ns("ind"), label = "Select one indivdual", value = 1),
    plotOutput(ns("plot"))
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
