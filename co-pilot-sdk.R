## Provided testing datasets in `./data/raw`: 
## "input1_pigeons.rds", "input2_geese.rds", "input3_stork.rds", "input4_goat.rds"  
## for own data: file saved as a .rds containing a object of class MoveStack
inputFileName = "./data/raw/input1_pigeons.rds" 
## optionally change the output file name
dir.create("./data/output/")
outputFileName = "./data/output/output.rds" 

#################################################################
########################### Arguments ###########################
# The data parameter will be added automatically if input data is available
# The name of the field in the vector must be exactly the same as in the r function signature
# Example:
# rFunction = function(username, department)
# The parameter must look like:
#    args[["username"]] = "any-username"
#    args[["department"]] = "any-department"

args <- list()
# Add your arguments of your r-function here
args[["year"]] = 2014 

# this file is the home of your app code and will be bundled into the final app on MoveApps
source("ShinyModule.R")

# setup your environment
Sys.setenv(
    SOURCE_FILE = inputFileName, 
    OUTPUT_FILE = outputFileName, 
    ERROR_FILE="./data/output/error.log", 
    APP_ARTIFACTS_DIR ="./data/output/artifacts"
)

# simulate running your app on MoveApps
source("src/moveapps.R")
simulateMoveAppsRun(args)
