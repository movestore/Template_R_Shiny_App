# tie everything together
# the following files will NOT bundled into the final app - they are just helpers in the SDK
source("src/common/logger.R")
source("src/common/runtime_configuration.R")
source("src/io/app_files.R")
source("src/io/io_handler.R")
source("src/io/rds.R")

library("shiny")
library("tidyverse")
library("fs")

Sys.setenv(tz="UTC")

ui <- function(request) { 
  fluidPage(
    tags$head(singleton(tags$script(src = 'ws-keep-alive-fix.js'))),
    tags$link(rel = "stylesheet", type = "text/css", href = "ws-keep-alive-fix.css"),
    shinyModuleUserInterface("shinyModule"),
    dataTableOutput("table"), #Is necessary for storing result

    # ws-heartbeat fix
    # kudos: https://github.com/rstudio/shiny/issues/2110#issuecomment-419971302
    textOutput("ws_heartbeat"),
    bookmarkButton(title="Bookmark current settings of this app (needed to correctly run in workflows)",class="btn btn-outline-success")
  )
}

server <- function(input, output, session) {
  
  observeEvent(session, {
    if(file_exists(path("shiny_bookmarks/latest/input.rds")) && is.null(parseQueryString(session$clientData$url_search)$`_state_id_`)){
      updateQueryString(queryString = "?_state_id_=latest")
      session$reload() 
    }
  }, once = TRUE)

  tryCatch(
  {
    data <- readInput(sourceFile())
    shinyModuleArgs <- c(shinyModule, "shinyModule")
    if (!is.null(data)) {
        shinyModuleArgs[["data"]] <- data
    }

    result <- do.call(callModule, shinyModuleArgs)

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
  
  onBookmarked(function(url) {
    if(!dir_exists("shiny_bookmarks/latest")){
      dir_create("shiny_bookmarks/latest")
    }
    file_move(path = path("shiny_bookmarks", parseQueryString(sub("^.*\\?", "", url))$`_state_id_`, "input.rds"), new_path = path("shiny_bookmarks/latest/input.rds"))
    dir_delete(path("shiny_bookmarks", parseQueryString(sub("^.*\\?", "", url))$`_state_id_`))
  })
}

simulateMoveAppsRun <- function(args) {
  storeConfiguration(args)
  shinyApp(ui, server, enableBookmarking="server")
}
