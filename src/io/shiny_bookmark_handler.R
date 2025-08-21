library("fs")
library("jsonlite")

bookmarkRootDir = "shiny_bookmarks" # it seems impossible to change the root-dir :/
bookmarkDir <- paste0(bookmarkRootDir, "/latest")
# `input.rds` is the expected file name by shiny!
bookmarkFileName <- "input.rds"
bookmarkRdsTargetPath <- path(bookmarkDir, bookmarkFileName)
# `input.json` is a custom file-name and a custom file-content to access the shiny values in plain text
bookmarkJsonName <- "input.json"
bookmarkJsonTargetPath <- path(bookmarkDir, bookmarkJsonName)

saveBookmarkAsLatest <- function(url) {
  stateId <- parseQueryString(sub("^.*\\?", "", url))$`_state_id_`
  if(!dir_exists(bookmarkDir)){
    dir_create(bookmarkDir)
  }
  file_move(
    path = path("shiny_bookmarks", stateId, bookmarkFileName),
    new_path = bookmarkRdsTargetPath
  )
  dir_delete(path("shiny_bookmarks", stateId))
  logger.debug(paste("[bookmark] Moved shiny bookmark", stateId, "to", bookmarkDir))
}

restoreShinyBookmark <- function(session) {
  if(file_exists(bookmarkRdsTargetPath) && is.null(parseQueryString(session$clientData$url_search)$`_state_id_`)) {
    updateQueryString(queryString = "?_state_id_=latest")
    logger.debug("[bookmark] Reloading session b/c of detected (not yet loaded) shiny bookmark")
    session$reload()
  }
}

# a plain text variant of the input for usage outside R
saveInputAsJson <- function(jsonString) {
  tryCatch(
    {
      writeLines(jsonString, bookmarkJsonTargetPath)
      logger.debug("[bookmark] Persisted shiny input as JSON")
    },
    error = function(e) {
      logger.error(paste("[bookmark] Could not write shiny input JSON file:", e))
    })
}
