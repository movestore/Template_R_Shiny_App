clearRecentOutput <- function() {
    if (Sys.getenv(x = "CLEAR_OUTPUT", "no") == "yes") {
        logger.info("Clearing recent output")
        # delete and recreate artifact directory if it exists
        artifact_dir <- Sys.getenv(x = "APP_ARTIFACTS_DIR", "")
        if (artifact_dir != "") {
            unlink(artifact_dir, recursive = TRUE)
            dir.create(artifact_dir)
            file.create(file.path(artifact_dir, ".keep"))
        }
        # delete app output file
        output_file <- Sys.getenv(x = "OUTPUT_FILE", "")
        if (output_file != "") {
            unlink(output_file)
        }
        # delete the shiny bookmark
        unlink("./shiny_bookmarks/latest/input.rds")
    }
}