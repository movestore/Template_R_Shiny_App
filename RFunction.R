library('move')
library('lubridate')

## The parameter "data" is reserved for the data object passed on from the previous app

# to display messages to the user in the log file of the App in MoveApps
# one can use the function from the logger.R file:
# logger.fatal(), logger.error(), logger.warn(), logger.info(), logger.debug(), logger.trace()

# Showcase injecting app setting (parameter `year`)
rFunction = function(data, sdk, year, ...) {
  logger.info(paste("Welcome to the", sdk))
  result <- if (any(lubridate::year(data@timestamps) == year)) { 
    data[lubridate::year(data@timestamps) == year]
  } else {
    NULL
  }
  if (!is.null(result)) {
    # Showcase creating an app artifact. 
    # This artifact can be downloaded by the workflow user on Moveapps.
    artifact <- appArtifactPath("plot.png")
    logger.info(paste("plotting to artifact:", artifact))
    png(artifact)
    plot(result)
    dev.off()
  } else {
    logger.warn("nothing to plot")
  }
  # Showcase to access a file ('auxiliary files') that is 
  # a) provided by the app-developer and 
  # b) can be overridden by the workflow user.
  fileName <- paste0(getAppFilePath("yourLocalFileSettingId"), "sample.txt")
  logger.info(readChar(fileName, file.info(fileName)$size))

  # provide my result to the next app in the MoveApps workflow
  return(result)
}
