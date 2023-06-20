configuration <- function() {
    configurationFile <- Sys.getenv(x = "CONFIGURATION_FILE", "")

    result <- if(configurationFile != "") {
        jsonlite::fromJSON(txt=configurationFile)
    } else {
        NULL
    }

    if (Sys.getenv(x = "PRINT_CONFIGURATION", "no") == "yes") {
        logger.debug("parse stored configuration: \'%s\'", configurationFile)
        logger.info("app will be started with configuration:\n%s", jsonlite::toJSON(result, auto_unbox = TRUE, pretty = TRUE))
    }
    result
}
