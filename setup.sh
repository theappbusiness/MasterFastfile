#!/bin/bash

mkdir fastlane
cd fastlane
echo "app_identifier = ENV['FL_UPDATE_PLIST_APP_IDENTIFIER']" > Appfile
echo "fastlane_version \"1.55.0\"
import_from_git(url: 'https://github.com/theappbusiness/MasterFastfile.git', path: 'Fastfile')" > Fastfile
make_default_env_file()
make_custom_env_file("test")
make_custom_env_file("uat")
make_custom_env_file("staging")
make_custom_env_file("prod")

function make_default_env_file() {
  cat > .env.default <<EOF
#This is your default environment file
#Set environment variables used in all builds here
#More information on available environment variables can be found here https://github.com/theappbusiness/MasterFastfile/wiki/Quick-simple-setup-using-TAB-defaults
FL_HOCKEY_API_TOKEN="" #Hocky API Token
FL_HOCKEY_OWNER_ID="" #Hockey Organisation ID (number not name)
FL_UPDATE_PLIST_PATH="" #Path to Info.plist
GYM_CODE_SIGNING_IDENTITY="" #Code Sign Identitify
FL_HOCKEY_TEAMS="" #Hockey ID (number not name)
FL_HOCKEY_NOTIFY= #Email team when new build avialable? 0 = No, 1 = Yes
ICON_OVERLAY_ASSETS_BUNDLE="" #Path to .xcassets
TAB_USE_TIME_FOR_BUILD_NUMBER= #Use Time and date for build number or BUILD_NUMBER environment variable (created by jenkis or team city) true = use time, false = use BUILD_NUMBER
EOF
}

function make_custom_env_file() {
  env=$0
  cat > .env.$env <<EOF
#This is your ${env} environment file
#Set environment variables used in ${env} builds here
GYM_SCHEME="" #Scheme name
FL_UPDATE_PLIST_APP_IDENTIFIER="" #App Bundle Identifier
FL_UPDATE_PLIST_DISPLAY_NAME="" #Display name of app
EOF
}
