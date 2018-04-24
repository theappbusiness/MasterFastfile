# CHANGELOG

## [4.0.0]("https://github.com/theappbusiness/MasterFastfile/releases/tag/4.0.0")
### Changed
- Multiple code-level changes for addressing Rubocop errors.
- Provfiles are no longer used, instead you should define export options.
- All provisioning profiles included in the `fastlane` directory now get installed automatically.
- Updated `setup.sh`.
- Fixed an issue with including a Hockey download link when messaging to Slack.
- Fixed an issue where using `get_current_version` with the latest version of Fastlane would cause a prompt for the target.

## [3.0.1](https://github.com/theappbusiness/MasterFastfile/releases/tag/3.0.1)
### Added
- Release badge and link pointing to latest release version

### Changed
- CHANGELOG format

## [3.0.0](https://github.com/theappbusiness/MasterFastfile/releases/tag/3.0.0)
### Changed
- If `FL_PROJECT_TEAM_ID` is not set, the team ID is extracted from the environment's `GYM_EXPORT_OPTIONS` plist.

### Removed
- Use of `TAB_EXPORT_METHOD`, instead extracting the export method from the environment's `GYM_EXPORT_OPTIONS` plist.

## [2.3.0](https://github.com/theappbusiness/MasterFastfile/releases/tag/2.3.0)
### Added
- Lane dedicated to running `ui_test` schemes

## [2.2.0](https://github.com/theappbusiness/MasterFastfile/releases/tag/2.2.0)
### Added
- Support for signing multiple target projects using Provfile's

## [2.1.0](https://github.com/theappbusiness/MasterFastfile/releases/tag/2.1.0)
### Added
- `deploy_to_test_flight` for building and uploading to iTunes Connect

## [2.0.0](https://github.com/theappbusiness/MasterFastfile/releases/tag/2.0.0)
### Added
- New enviroment variable `TAB_EXPORT_METHOD` needed for `gym`, possible values are:
	- "app-store"
	- "ad-hoc"
	- "development"
	- "enterprise" // If not set this is used by default

### Changed
- Renamed `hockey` to `deploy_to_hockey`
- Renamed `hockey_no_test` to `deploy_to_hockey_no_test`

## [1.6.0](https://github.com/theappbusiness/MasterFastfile/releases/tag/1.6.0)
### Added
- Support for updating the team ID if `FL_PROJECT_SIGNING_PROJECT_PATH` and  `FL_PROJECT_TEAM_ID` are set

## [1.5.0](https://github.com/theappbusiness/MasterFastfile/releases/tag/1.5.0)
### Added
- `local_build` for building ipas locally

## [1.4.0](https://github.com/theappbusiness/MasterFastfile/releases/tag/1.4.0)
### Added
- Support for updating `PRODUCT_BUNDLE_IDENTIFIER`

## [1.3.0](https://github.com/theappbusiness/MasterFastfile/releases/tag/1.3.0)
### Added
- Support for installing a provisioning profile

## [1.2.0](https://github.com/theappbusiness/MasterFastfile/releases/tag/1.2.0)
### Added
- Support for Xcode 8 provisioning profile specifier
