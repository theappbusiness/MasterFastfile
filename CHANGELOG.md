# CHANGELOG

## 2.0.1

- Added support for signing multiple target projects using Provfile's

## 2.0.0

- Renamed `hockey` to `deploy_to_hockey`
- Renamed `hockey_no_test` to `deploy_to_hockey_no_test`
- Added new enviroment variable `TAB_EXPORT_METHOD` needed for `gym`, possible values are:
	- "app-store"
	- "ad-hoc"
	- "development"
	- "enterprise" // If not set this is used by default

## 1.6.0

- Added support for updating the team ID if `FL_PROJECT_SIGNING_PROJECT_PATH` and  `FL_PROJECT_TEAM_ID` are set

## 1.5.0

- Added `local_build` for building ipas locally

## 1.4.0

- Support for updating `PRODUCT_BUNDLE_IDENTIFIER`

## 1.3.0

- Support for installing a provisioning profile

## 1.2.0

- Support for Xcode 8 provisioning profile specifier
