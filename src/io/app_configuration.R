storeConfiguration <- function(configuration) {
  write_json(configuration, "configuration.json", auto_unbox = TRUE)
  logger.info("Stored configuration of shinyModule to 'configuration.json'")
}
