# Changelog SDK

## 2023-10 `v3.0.3`

- bugfix result/output observation (`'data' must be 2-dimensional`)

## 2023-09 `v3.0.2`

- introduce `appspec.json` version `1.1`
    - documentation link is not required any more

## 2023-08 `v3.0.1`

- removed MoveApps IO-Type dependency
- provide new move2 input files
- bugfix app-file loading

## 2023-06 `v3.0.0`

- introduces template versioning (starting w/ `v3.0.0` as this is the third major iteration)
- introduces `dotenv` to control/adjust local app-development
- updates developer readme
- clear app output of previously app run at each start of the SDK
- introduces a _Template Synchronization_ GH action. Use it to synchronize your forked app with template updates. If you already forked from the template _before_ SDK `v3.0.0` you can manually add the files `.github/workflows/template-sync.yml` and `.github/.templatesyncignore` to your fork. With these files you can manually execute the GH action named _Template Synchronization_. *Only use this option if your app is written for input data of class `move2`*

- fix app-configuration for execution on moveapps.org
- clear app output of previously app run at each start of the SDK

- SDK supports [`move2`](https://gitlab.com/bartk/move2/), if input is of class [`move`](https://gitlab.com/bartk/move/) it will be converted into class `move2`.
- output is always move2
- Upgrade `R` framework to `4.3.1`
