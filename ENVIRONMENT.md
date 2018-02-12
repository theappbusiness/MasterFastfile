# Supporting multiple environments

The MasterFastfile uses some standard Fastlane environment variables, some of which the MasterFastfile requires for distribution to HockeyApp or iTunes Connect.

Additionally, there are some proprietary TAB environment variables that we use for things like UI testing. In this file you'll find a full list of environment variables that the MasterFastile uses, will help you determine if you need to set them in your setup.

## Standard Fastlane environment variables
### Required

`FL_PROJECT_SIGNING_PROJECT_PATH`

`FL_UPDATE_PLIST_PROJECT_PATH`

`FL_UPDATE_PLIST_PATH`

`FL_UPDATE_PLIST_APP_IDENTIFIER`

`GYM_EXPORT_OPTIONS`

`ITUNES_CONNECT_USERNAME`

`ITUNES_CONNECT_TEAM_ID`

`ITUNES_CONNECT_PROVIDER`

### Optional

`SLACK_URL`

`SCAN_SLACK_CHANNEL`

`FL_SLACK_CHANNEL`

`SCAN_SCHEME`

`GYM_SCHEME`

`SCAN_DEVICE`

`BUILD_NUMBER`

`FL_PROJECT_TEAM_ID` (If ommitted we'll try to get the team id out of the export options plist)

`ICON_OVERLAY_SOURCE_PATH`

`ICON_OVERLAY_ASSETS_BUNDLE`

`ICON_OVERLAY_APP_VERSION`

`ICON_OVERLAY_TITLE`

## Proprietary TAB environment variables

`TAB_SLACK_WEBHOOK_URL`

`TAB_UI_TEST_DEVICES`

`TAB_REPORT_FORMATS`

`TAB_OUTPUT_TYPES`

`TAB_UI_TEST_SCHEME`

`TAB_XCODE_PATH`

`TAB_USE_TIME_FOR_BUILD_NUMBER`

`TAB_HOCKEY_RELEASE_NOTES`
