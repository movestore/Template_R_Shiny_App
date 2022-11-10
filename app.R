library("shiny")
library("move")

shinyModuleUserInterface <- function(id, label) {
  ns <- NS(id) ## all IDs of UI functions need to be wrapped in ns()
  tagList(
    titlePanel("Plot of Track"),
    numericInput(inputId = ns("ind"), label = "Select one indivdual", value = 1),
    plotOutput(ns("plot"))
  )
}

shinyModule <- function(input, output, session, data){ ## The parameter "data" is reserved for the data object passed on from the previous app
  ns <- session$ns ## all IDs of UI functions need to be wrapped in ns()
  data <- readRDS("./data/raw/input2_geese.rds")
  current <- reactiveVal(data)
  
  output$plot <- renderPlot({
    plot(data[[input$ind]])
  })
  
  return(reactive({ current() }))
}

##################

library("shiny")
library("fs")
library("tidyverse")

Sys.setenv(tz="UTC")

ui <- function(request) { 
  fluidPage(
    shinyModuleUserInterface("shinyModule"),
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
  
  callModule(shinyModule,"shinyModule")
  
  onBookmarked(function(url) {
    if(!dir_exists("shiny_bookmarks/latest")){
      dir_create("shiny_bookmarks/latest")
    }
    file_move(path = path("shiny_bookmarks", parseQueryString(sub("^.*\\?", "", url))$`_state_id_`, "input.rds"), new_path = path("shiny_bookmarks/latest/input.rds"))
    dir_delete(path("shiny_bookmarks", parseQueryString(sub("^.*\\?", "", url))$`_state_id_`))
  })
}
  
shinyApp(ui, server, enableBookmarking="server")

