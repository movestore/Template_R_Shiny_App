# tie everything together
# the following files will NOT bundled into the final app - they are just helpers in the SDK
source("src/common/logger.R")
source("src/common/runtime_configuration.R")
source("src/io/app_files.R")
source("src/io/io_handler.R")
source("src/io/rds.R")

library("shiny")

Sys.setenv(tz="UTC")

ui <- function() {
  fluidPage(
    tags$head(singleton(tags$script(src = 'ws-keep-alive-fix.js'))),
    tags$link(rel = "stylesheet", type = "text/css", href = "ws-keep-alive-fix.css"),
    do.call(shinyModuleUserInterface, c("shinyModule", "shinyModule", configuration())),
    dataTableOutput("table"), #Is necessary for storing result

    if (exists("shinyModuleConfiguration")) {
      actionButton("storeConfiguration", "Store configuration")
    },

    # ws-heartbeat fix
    # kudos: https://github.com/rstudio/shiny/issues/2110#issuecomment-419971302
    textOutput("ws_heartbeat")
  )
}

server <- function(input, output, session) {
  tryCatch(
  {
    data <- readInput(sourceFile())
    shinyModuleArgs <- c(shinyModule, "shinyModule", configuration())
    if (!is.null(data)) {
        shinyModuleArgs[["data"]] <- data
    }

    result <- do.call(callModule, shinyModuleArgs)

    observeEvent(input$storeConfiguration, {
      configuration <- shinyModuleConfiguration("shinyModule", input)
      storeConfiguration(configuration)
    })

    output$table <- renderDataTable({
      storeResult(result(), outputFile())
      notifyDone("SHINY")
    })
  },
  error = function(e) {
    # error handler picks up where error was generated
    print(paste("ERROR: ", e))
    storeToFile(e, errorFile())
    if (grepl("[code 10]", e$message, fixed=TRUE)) {
      stopApp(10)
    } else {
      stop(e) # re-throw the exception
    }
  })

  # ws-heartbeat fix
  # kudos: https://github.com/rstudio/shiny/issues/2110#issuecomment-419971302
  output$ws_heartbeat <- renderText({
    req(input$heartbeat)
    input$heartbeat
  })
}

simulateMoveAppsRun <- function(args) {
  storeConfiguration(args)
  shinyApp(ui, server)
}
