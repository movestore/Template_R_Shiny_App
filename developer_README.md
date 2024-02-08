# MoveApps R-SHINY Software Development Kit (SDK)

#### ***NOTE*: this SDK only supports code written for input data of class `move2` and not `moveStack`, as all input data of class `moveStack` will be converted to class `move2`. For all other input/output types, this SDK works as usual. Please contact us under support@moveapps.org if you have any questions.**

This documentation provides a short introduction to the [MoveApps](https://www.moveapps.org) **R-SHINY SDK**.

As a first step, and before your read this, you should have forked this GitHub template to your personal space and named the repository as your App will be named in MoveApps.

A general overview provides the [MoveApps user manual](https://docs.moveapps.org/#/create_app)

# Overview

This template is designed according to a file structure that is necessary for your App to run in your local development environment similar to the way it will run in the MoveApps environment later. Please contain the structure and only change/add files as necessary for your App's functionality. See below which files can be changed and which should remain as is for simulation of the behaviour on MoveApps on your local system. A stepwise explanation below indicates the function and some background of each file and folder.

## File structure

(truncated)

```
.
├── Dockerfile
├── README.md
├── Template_R_Shiny_App.Rproj
├── ShinyModule.R
├── appspec.json
├── data
│   ├── local_app_files
│   ├── output
│   └── raw
│       ├── input1.rds
│       ├── input2.rds
│       ├── input3.rds
│       └── input4.rds
├── renv.lock
├── sdk.R
├── src
│   ├── common
│   │   ├── logger.R
│   ├── io
│   │   ├── app_files.R
│   │   ├── io_handler.R
│   │   ├── rds.R
│   │   └── shiny_bookmark_handler.R
│   └── moveapps.R
└── start-process.sh


```

1. `./ShinyModule.R`: This is the entrypoint for your App logic. MoveApps will call this module during a workflow execution which includes your App. **The file must be named `ShinyModule.R`, do not alter it!**
1. `./appspec.json`: This file defines the settings and metadata of your App, for details refer to the [MoveApps User Manual](https://docs.moveapps.org/#/appspec)
1. `./renv.lock`: Definition of the dependencies of your App. We use `renv` as library manager. Optional.
1. `./data/**`: Resources of the SDK
   1. `local_app_files/**`: Simulates the usage of [*app files*](https://docs.moveapps.org/#/auxiliary). You can put files into this folder to simulate an App run with provided/user-uploaded files. 
   1. `output/**`: If your App produces [*artefacts*](https://docs.moveapps.org/#/copilot-r-sdk?id=artefacts) they will be stored here.
   1. `raw/**`: Collection of sample App input data. You can use these samples to simulate an App run with real input.
1. `./sdk/**`: The (internal) MoveApps R SDK logic.
1. `./sdk.R`: The main entry point of the SDK. Use it to execute your App in your IDE.

## SDK Runtime environment

Critical parts of the SDK can be adjusted by `environment variables`. 
Keep in mind that these variables are only changeable during App development and not during an App run on MoveApps.
They are predefined with sensible defaults - they should work for you as they are.

- `SOURCE_FILE`: path to an input file for your App during development
- `OUTPUT_FILE`: path to the output file of your App
- `APP_ARTIFACTS_DIR`: base directory for writing App artifacts
- `LOCAL_APP_FILES_DIR`: base directory of your local App files (*auxiliary*)
- `CLEAR_OUTPUT`: clears all output of the previously app run at each start of the SDK aka the next app start

You can adjust these environment variables by adjusting the file `./.env`.

The file `./.env` is **hidden** by default in `RStudio`! You can show it by

1. Tab `Files` in `RStudio`
1. `More` Button in the Files-Toolbar
1. Activate _Show Hidden Files_

## MoveApps App Bundle

Which files will be bundled into the final App running on MoveApps?

- the file `./ShinyModule.R
- all directories defined in your `appspec.json` at `providedAppFiles` 

Nothing else.

Note that many App features will be set and updated with information from the `appspec.json` in each new App version. Thus, even if not bundled into the App, this file is required and must be up to date.


## App development

1. Execute `Rscript sdk.R` (on a terminal) or run/source `sdk.R` in _RStudio_ (_Run App_)
1. Ensure the sdk executes the vanilla template App code. Everything is set up correctly if no error occurs and you can open the Shiny App in your local Web-Browser.
1. Begin with your App development in `./ShinyModule.R`

## Examples

### Request App configuration from your users

tbd (Shiny Bookmark instructions)

### Produce an App artefact

tbd (should be supported by SDK - must be tested by sample app implementation. Provide code snippets)

## Include files to your App

[Details and examples about _auxiliary files_](https://docs.moveapps.org/#/auxiliary).

This template also implements in `./ShinyModule.R` a showcase about this topics.

---

## R packages management / renv (optional)

The template is prepared to use [`renv` as a dependency manager](https://rstudio.github.io/renv/articles/renv.html) - but is disabled by default (_opt-in_).
You can [activate `renv` with `renv::activate()`](https://rstudio.github.io/renv/articles/renv.html#uninstalling-renv) and then use it in the [usual `renv` workflow](https://rstudio.github.io/renv/articles/renv.html#workflow).

### Docker support (optional)

- at the end your app will be executed on MoveApps in a Docker container.
- if you like you can test your app in the almost final environment by running your app locally in a docker container:

1. enable `renv` (see above)
1. set a working title for your app by `export MY_MOVEAPPS_APP=hello-world` (in your terminal)
1. build the Docker image locally by `docker build --platform=linux/amd64 -t $MY_MOVEAPPS_APP .` (in your terminal)
1. execute the image with `docker run --platform=linux/amd64 -p 3838:3838 --rm --name $MY_MOVEAPPS_APP -it $MY_MOVEAPPS_APP` (in your terminal)
1. you will get a `bash` terminal of the running container. There you can get a R console by `R` or simply start your app by invoking `/home/moveapps/co-pilot-r/start-process.sh` (in the `bash` of the running container)
1. after starting the process open your app UI by navigating to `http://127.0.0.1:3838/` (in your local web browser)

## Synchronisation of your fork with this template

This template includes a _GitHub action_ to keep your fork synchronized with the original template (aka the MoveApps R SDK). The synchronization action creates a _GitHub pull request_ in your fork from time to time in case the original template has changed.
