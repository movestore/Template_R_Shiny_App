notifyDone <- function(executionType) {
  logger.debug("[http fake client] notify done")
}

notifyPushBookmark <- function(fileName) {
  logger.debug(paste("[http fake client] notify push (shiny) bookmark", fileName))
}
