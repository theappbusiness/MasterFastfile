fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
### test
```
fastlane test
```
Runs all unit tests that are included in the scheme.

It's not recommended to include UI tests in this scheme, instead run the "ui_test" lane.
### ui_test
```
fastlane ui_test
```
Runs UI tests that are included in the scheme.

Environment variables to use: `TAB_UI_TEST_DEVICES`, `TAB_REPORT_FORMATS`, `TAB_UI_TEST_SCHEME`
### deploy_to_hockey
```
fastlane deploy_to_hockey
```
Runs all unit tests before deploying to HockeyApp.
### deploy_to_hockey_no_test
```
fastlane deploy_to_hockey_no_test
```
Deploys to HockeyApp without running any tests.
### deploy_to_test_flight
```
fastlane deploy_to_test_flight
```
Runs all unit tests before deploying to TestFlight.
### local_build
```
fastlane local_build
```
Creates a local IPA build without running any tests.

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
