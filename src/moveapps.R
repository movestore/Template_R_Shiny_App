# tie everything together
# the following files will NOT bundled into the final app - they are just helpers in the SDK
source("src/common/logger.R")
source("src/io/app_files.R")
source("src/io/io_handler.R")
source("src/io/shiny_bookmark_handler.R")
source("src/io/rds.R")
source("src/io/pilot_client.R")

# `./ShinyModule.R` is the home of your app code
# It is the only file which will be bundled into the final app on MoveApps
source("ShinyModule.R")

Sys.setenv(tz="UTC")

ui <- function(request) { 
  fluidPage(
    tags$head(singleton(tags$script(src = 'ws-keep-alive-fix.js'))),
    tags$link(rel = "stylesheet", type = "text/css", href = "ws-keep-alive-fix.css"),
    shinyModuleUserInterface("shinyModule"),

    # ws-heartbeat fix
    # kudos: https://github.com/rstudio/shiny/issues/2110#issuecomment-419971302
    textOutput("ws_heartbeat"),
    # store the current state (as a shiny bookmark)
    bookmarkButton(label="Store settings", title="Click here to store the current chosen settings for future runs of the workflow",class="btn btn-outline-success")
  )
}

server <- function(input, output, session) {
  tryCatch(
  {
    data <- readInput(sourceFile())
    shinyModuleArgs <- c(shinyModule, "shinyModule")
    if (!is.null(data)) {
        shinyModuleArgs[["data"]] <- data
    }

    result <- do.call(callModule, shinyModuleArgs)

    observeEvent(
      session,
      {
        restoreShinyBookmark(session)
      },
      once = TRUE
    )

    observe({
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
  
  # hook after persisting the bookmark
  # see https://shiny.rstudio.com/articles/advanced-bookmarking.html
  onBookmarked(function(url) {
    saveBookmarkAsLatest(url)
    notifyPushBookmark(getLatestBookmarkFile())
  })
}
