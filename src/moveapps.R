# simulate an app run on moveapps.org

simulateMoveAppsRun <- function(args) {
    tryCatch(
    {
        Sys.setenv(tz="UTC")

        data <- readInput(sourceFile())
        if (!is.null(data)) {
            args[["data"]] <- data
        }

        result <- do.call(rFunction, args)
        storeResult(result, outputFile())
    },
    error = function(e)
    {
        # error handler picks up where error was generated
        print(paste("ERROR: ", e))
        storeToFile(e, errorFile())
        stop(e) # re-throw the exception
    })
}