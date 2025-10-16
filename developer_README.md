# MoveApps R-SHINY Software Development Kit (SDK)

***NOTE*: this SDK supports code written for input data of class `move2` and not `moveStack`, as all input data of class `moveStack` will be converted to class `move2`. For all other input/output types, this SDK works as usual. Please contact us under support@moveapps.org if you have any questions.**

This documentation provides a short introduction to the [MoveApps](https://www.moveapps.org) **R-SHINY SDK**.

As a first step, and before your read this, you should have used this GitHub template to create a copy of it in your personal space and named the repository as your App will be named in MoveApps.

**The [MoveApps User Manual](https://docs.moveapps.org/#/create_app) provides a step-by-step explanation of how to create an App.** Please carefully follow these steps when creating a MoveApps App.


## Files in the SDK/template

This template is designed according to a file structure that is necessary for your App to run in your local development environment similar to the way it will run in the MoveApps environment later. Please contain the structure and only change/add files as necessary for your App's functionality. Take a look at the [overview in the User Manual](https://docs.moveapps.org/#/create_app) to see which files can be changed and which should remain as is for simulation of the behaviour on MoveApps on your local system.

Here you find an overview of the files and their function in the SDK:

1. `./ShinyModule.R`: must be modified by the developer. This is the entrypoint for your App logic. MoveApps will call this function during a Workflow execution which includes your App. The file must be named `ShinyModule.R`, do not alter it. It is also possible to source additional R scripts. See [Step 3](https://docs.moveapps.org/#/create_app#step-3-develop-the-app-code-locally-within-the-template) in the User Manual.
1. `./appspec.json`: must be modified by the developer. This file defines the settings and metadata of your App. See [Step 6](https://docs.moveapps.org/#/create_app?id=step-6-write-app-specifications) in the User Manual.
1. `./README.md`: must be modified by the developer. Provided template for the documentation of the App (see [Step 7](https://docs.moveapps.org/#/create_app?id=step-7-write-a-documentation-file) in the User Manual).
1. `./renv.lock`: Definition of the dependencies of your App. We use `renv` as library manager. Optional, see below.
1. `./data/**`: Resources of the SDK
1. `./sdk.R`: use for App testing. The main entrypoint of the SDK. Use it to execute your App in your compiler (e.g. RStudio).
1. `/.env`: adjust for App testing. Defining the SDK Runtime environment, see below. Make sure to check _Show Hidden Files_ in the settings menu of the _Files_ tab in RStudio.
1. `./data/**`: use for App testing. Resources of the SDK
   1. `auxiliary/**`: Simulates the usage of [*auxiliary files*](https://docs.moveapps.org/#/auxiliary). You can put files into this folder to simulate an App run with provided/user-uploaded files. 
   1. `output/**`: The output data (`output.rds`) that will be passed on to the next App in a Workflow and other output files (artifacts) that your App may produce will be stored here. See [*producing artifacts*](https://docs.moveapps.org/#/copilot-shiny-sdk?id=producing-artefacts) for more information.
   1. `raw/**`: Collection of sample App input data. You can use these samples to simulate an App run with real input.
1. all remaining files are used to emulate MoveApps when testing the App locally, to setup the automatic sync of your repository with the template, or to provide information related to the template. **These files are not to be modified**. Modifying them will prevent you from testing your App appropriately. 

## SDK runtime environment

Critical parts of the SDK can be adjusted by `environment variables`. Keep in mind that these variables are only changeable during App development and not during an App run on MoveApps. They are predefined with sensible defaults - they should work for you as they are. While testing your App you will want to modify the `SOURCE_FILE` variable to either call the different example data sets provided in the template or other data sets that you want to use to test your App.

- `SOURCE_FILE`: path to an input file for your App during development
- `OUTPUT_FILE`: path to the output file of your App
- `ERROR_FILE`: path to a file collecting error messages
- `APP_ARTIFACTS_DIR`: base directory for writing App artifacts
- `USER_APP_FILE_HOME_DIR`: home aka base directory of your local user/auxiliary App files
- `CLEAR_OUTPUT`: clears all output of the previously app run at each start of the SDK aka the next app start

You can adjust these environment variables by adjusting the file `./.env`.

The file `./.env` is **hidden** by default in `RStudio`! You can show it by

1. Tab `Files` in `RStudio`
1. `More` Button in the Files-Toolbar
1. Activate _Show Hidden Files_


## MoveApps App Bundle

Which files will be bundled into the final App running on MoveApps?

- the file `./ShinyModule.R`
- everything inside the `./src/app/` directory. You have to ensure you source any scripts in this (sub)directory yourself. You can do this by defining, for example, `source(./src/app/common/common.R)` in your `shinyModule()`.
- all directories defined in your `appspec.json` at `providedAppFiles`

- the file `./appspec.json` will be used to build and create the metadata of your App
- the file `./README.md` will be reference to for the documentation of your App

Nothing else.


## R packages management / renv (optional)

The template is prepared to use [`renv` as a dependency manager](https://rstudio.github.io/renv/articles/renv.html) - but is disabled by default (_opt-in_).
You can [activate `renv` with `renv::activate()`](https://rstudio.github.io/renv/articles/renv.html#uninstalling-renv) and then use it in the [usual `renv` workflow](https://rstudio.github.io/renv/articles/renv.html#workflow).


### Docker support (optional)

Your app will be executed on MoveApps in a Docker container. Specially for debugging errors that are not straight forward, it can be very useful to execute your App in a docker container. These more complex errors are often due to system libraries that need to be installed in MoveApps to run the App. The easiest way to find out which ones they are is to run the App locally in a docker container:

1. enable `renv` (see above)
1. set a working title for your app by `export MY_MOVEAPPS_APP=hello-world` (in your terminal)
1. build the Docker image locally by `docker build --platform=linux/amd64 -t $MY_MOVEAPPS_APP .` (in your terminal)
1. execute the image with `docker run --platform=linux/amd64 -p 3838:3838 --rm --name $MY_MOVEAPPS_APP -it $MY_MOVEAPPS_APP` (in your terminal)
1. you will get a `bash` terminal of the running container. There you can get a R console by `R` or simply start your app by invoking `/home/moveapps/co-pilot-r/start-process.sh` (in the `bash` of the running container)
1. after starting the process open your app UI by navigating to `http://127.0.0.1:3838/` (in your local web browser)


## Synchronisation of your fork with this template

This template includes a _GitHub action_ to keep your copy synchronized with the original template. Take a look at the [documentation](https://docs.moveapps.org/#/manage_Rapp_github?id=keep-your-repositories-up-to-date-sync-with-templates) and make sure to keep your repository up-to-date.
