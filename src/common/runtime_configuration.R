configuration <- function() {
    configurationString <- Sys.getenv(x = "CONFIGURATION_FILE", "{}")

    result <- if(configurationString != "") {
        jsonlite::fromJSON(txt=configurationString)
    } else {
        NULL
    }

    if (Sys.getenv(x = "PRINT_CONFIGURATION", "no") == "yes") {
        logger.debug("parse stored configuration: \'%s\'", configurationString)
        logger.info("app will be started with configuration:\n%s", jsonlite::toJSON(result, auto_unbox = TRUE, pretty = TRUE))
    }
    result
}
