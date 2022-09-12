#' Provides the path to app-files. App-files are files that
#' - are needed by the app to work during run time
#' - gets uploaded by the user of this app during configuration time
#' - must not exist during runtime (eg the user did not upload anything)
#' - can also be provided by the app developer and gets bundled into the app during build time (the fallback)
#' 
#' @param targetDirectory The parent directory of the requested set of app-files (see counterpart in `appspec.json`)
#' @param fallbackToProvidedFiles Fallback to bundled directory of requested set of app-files (in case the app-developer provided a fallback)?
#' @return Path to the requested set of files (the app-file parent directory). Or `NULL` if user did not upload anything and no fallback was provided
appFileTargetDirectory <- function(targetDirectory, fallbackToProvidedFiles=TRUE) {
    if(!is.null(targetDirectory) && targetDirectory != "") {
        userUpload <- paste0(Sys.getenv(x = "LOCAL_APP_FILES_DIR", "./uploaded-app-files/"), targetDirectory, "/")
        if (file.exists(userUpload) && list.files(userUpload) > 0) {
            # directory exists and is not empty: user provided some files
            logger.debug(paste0("Detected app-files provided by user for '", targetDirectory, "'."))
            return(userUpload)
        } else if(fallbackToProvidedFiles) {
            # fall back to directory provided by app developer
            logger.debug(paste0("Using fallback files provided by app developer for '", targetDirectory, "'."))
            return(paste0("./provided-app-files/", targetDirectory, "/"))
        } else {
            logger.warn(paste0("No files present for app-files '", targetDirectory, "': User did not upload anything and the app did not provide fallback files."))
            return(NULL)
        }
    }
}
