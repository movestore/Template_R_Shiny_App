#' Provides the path to the auxiliary file.
#' An auxiliary file is a file that
#' - is needed by the app to work during run time
#' - gets uploaded by the user of this app during configuration time
#' - there will be no warning if the requested file is not available (eg the user did not upload anything and the app developer did not provide any fallback)
#' - can also be provided by the app developer and gets bundled into the app during build time (the fallback)
#' 
#' @param appSpecUserFileSettingId The ID of the requested set of app-files (see counterpart in `appspec.json` (setting[type=USER_FILE].id))
#' @param fallbackToProvidedFiles Fallback to bundled directory of requested auxiliary file (in case the app-developer provided a fallback)?
#' @return Path to requested file. Or `NULL` if user did not upload anything and no fallback was provided.
#' 
getAuxiliaryFilePath <- function(appSpecUserFileSettingId, fallbackToProvidedFiles=TRUE) {
    userUploadDir <- paste0(Sys.getenv(x = "USER_APP_FILE_HOME_DIR"), Sys.getenv(x = "USER_APP_FILE_UPLOAD_DIR", "/uploaded-app-files/"))
    appDevFallbackDir <- paste0(Sys.getenv(x = "USER_APP_FILE_HOME_DIR"), Sys.getenv(x = "USER_APP_FILE_FALLBACK_DIR", "/provided-app-files/"))
    dir <- getUploadDirOrFallbackDir(appSpecUserFileSettingId, fallbackToProvidedFiles, userUploadDir, appDevFallbackDir)
    if (is.null(dir)) {
        return(NULL)
    }
    if (length(list.files(dir)) != 1) {
        return(NULL)
    }
    # R vectors are one-based!
    return(paste0(dir, list.files(dir)[1]))
}

#' DEPRECATED!
#' This function handles app-settings of type `LOCAL_FILE`. This setting type was deprecated.
getAppFilePath <- function(appSpecUserFileSettingId, fallbackToProvidedFiles=TRUE) {
    .Deprecated("getAuxiliaryFilePath")
    ### please migrate from `LOCAL_FILE` to `USER_FILE` app-setting type.
    userUploadDir <- paste0(Sys.getenv(x = "LOCAL_APP_FILES_DIR"), "/uploaded-app-files/")
    appDevFallbackDir <- paste0(Sys.getenv(x = "LOCAL_APP_FILES_DIR"), "/provided-app-files/")
    return(getUploadDirOrFallbackDir(appSpecUserFileSettingId, fallbackToProvidedFiles, userUploadDir, appDevFallbackDir))
}

#' Provides the path to the directory of an auxiliary file.
#' This function should not be used by the app-developer directly (internal only).
#' Better use `getAuxiliaryFilePath` to get the path to the file instead to the parent directory only.
#' @keywords internal
getUploadDirOrFallbackDir <- function(appSpecUserFileSettingId, fallbackToProvidedFiles, userUploadDir, appDevFallbackDir) {
    if(!is.null(appSpecUserFileSettingId) && appSpecUserFileSettingId != "") {
        userUpload <- paste0(userUploadDir, appSpecUserFileSettingId, "/")
        if (file.exists(userUpload) && length(list.files(userUpload)) > 0) {
            # directory exists and is not empty: user provided some files
            logger.info(paste0("Detected app-files provided by user for '", appSpecUserFileSettingId, "'."))
            return(userUpload)
        } else if (fallbackToProvidedFiles) {
            # fallback to directory provided by app developer
            logger.info(paste0("Using fallback files provided by app developer for '", appSpecUserFileSettingId, "'."))
            return(paste0(appDevFallbackDir, appSpecUserFileSettingId, "/"))
        } else {
            logger.warn(paste0("No files present for app-files '", appSpecUserFileSettingId, "': User did not upload anything and the app did not provide fallback files."))
            return(NULL)
        }
    }
}

#' Provides the path to an app-artifact.
#' You can write the app generated file to this path and it will become available on MoveApps after each app run.
#' @param artifactName The name of the artifact
#' @return Path for the artifact. Use it to write your data
#'
appArtifactPath <- function(artifactName) {
    return(paste0(Sys.getenv(x = "APP_ARTIFACTS_DIR"), artifactName))
}