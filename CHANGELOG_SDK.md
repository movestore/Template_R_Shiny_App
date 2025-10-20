# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.0.0] - 2025-10

### Added
- Support for R source scripts from the `./src/app/` directory (must be sourced by the App Developer on their own)

### Changed
- Extracted MoveApps SDK scripts to R package [moveapps](https://github.com/movestore/moveapps-sdk-r-package) while keeping backward compatibility to v3
- Upgraded R to version 4.5.1 (`renv.lock` + `Dockerfile`)

### Removed
- App setting type `LOCAL_FILE` and its associated function `getAppFilePath()`

## [3.3.0] - 2025-08

### Added
- Extract app settings as a JSON file (bookmark.json)

## [3.2.0] - 2024-03

### Added
- Introduce app-setting-type `USER_FILE`

### Deprecated
- App-setting-type `LOCAL_FILE`

## [3.1.0] - 2024-02

### Added
- Introduce `appspec.json` version `1.2`
    - Verify to include the `null` option for setting types `DROPDOWN` and `RADIOBUTTONS` if `defaultValue` is set to `null`

### Changed
- MoveApps now tries to fetch artifacts for every running App

### Removed
- `createsArtifacts` from `appspec.json` (v1.2). It is safe to remove it completely from your `appspec.json`.
- `move1` dependency

## [3.0.5] - 2023-12

### Changed
- Updated input files for testing apps. Files now include `move2_loc` and `telemetry.list` I/O types, and projected and non-projected data. All details included in the README.txt in the data/raw folder

## [3.0.4] - 2023-11

### Changed
- Upgraded `R` framework to `4.3.2`

## [3.0.3] - 2023-10

### Fixed
- Result/output observation (`'data' must be 2-dimensional`)

## [3.0.2] - 2023-09

### Added
- Introduce `appspec.json` version `1.1`
    - Documentation link is not required anymore

## [3.0.1] - 2023-08

### Added
- Provide new `move2` input files

### Changed
- Removed MoveApps IO-Type dependency

### Fixed
- App-file loading

## [3.0.0] - 2023-06

### Added
- Template versioning (starting with `v3.0.0` as this is the third major iteration)
- `dotenv` to control/adjust local app development
- Template Synchronization GitHub action to synchronize your forked app with template updates
    - If you already forked from the template before SDK `v3.0.0` you can (*only use this option if your app is written for input data of class `move2`*):
        1. Manually add the files `.github/workflows/template-sync.yml` and `.github/.templatesyncignore` to your fork
        2. With these files you can manually execute the GitHub action named `.github/workflows/template-sync.yml`
        3. After merging the generated pull request add the file `app-configuration.json` manually to the root directory of your App
- SDK supports [`move2`](https://gitlab.com/bartk/move2/)
    - If input is of class [`move`](https://gitlab.com/bartk/move/) it will be converted into class `move2`
    - Output is always `move2`

### Changed
- Updated developer readme
- Upgraded `R` framework to `4.3.1`
- Clear app output of previously app run at each start of the SDK
- Fixed app configuration for execution on moveapps.org
