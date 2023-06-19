library(dotenv)
# You can control your local app development via environment variables.
# You can define things like input-data, app-configuration etc.
# Per default your environment is defined in `/.env`
load_dot_env()

# provide common stuff
source("src/common/logger.R")
source("src/common/runtime_configuration.R")

# Lets simulate running your app on MoveApps
source("src/moveapps.R")
shinyApp(ui, server, enableBookmarking="server")
