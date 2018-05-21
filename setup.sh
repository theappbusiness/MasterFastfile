#!/bin/bash

mkdir fastlane
cd fastlane
echo "app_identifier = ENV['FL_UPDATE_PLIST_APP_IDENTIFIER']" > Appfile
echo "fastlane_version \"1.55.0\"
import_from_git(url: 'https://github.com/theappbusiness/MasterFastfile.git', path: 'Fastfile')" > Fastfile

function make_default_env_file {
  cat > .env.default <<EOF
#This is your default environment file
#Set environment variables used in all builds here
#More information on available environment variables can be found here https://github.com/theappbusiness/MasterFastfile/wiki/Quick-simple-setup-using-TAB-defaults

FL_PROJECT_SIGNING_PROJECT_PATH="./yourproject.xcodeproj" # Path to your project (not workspace)
FL_UPDATE_PLIST_APP_IDENTIFIER="" #The app identifier you want your main target (the host app) to have
GYM_CODE_SIGNING_IDENTITY="" #Code Sign Identitify
GYM_EXPORT_OPTIONS="" #The export options, used for finding the export method and provisioning

FL_HOCKEY_API_TOKEN="" #Hocky API Token
FL_HOCKEY_OWNER_ID="" #Hockey Organisation ID (number not name)
FL_UPDATE_PLIST_PATH="" #Path to Info.plist
FL_HOCKEY_TEAMS="" #Hockey ID (number not name)
FL_HOCKEY_NOTIFY= #Email team when new build avialable? 0 = No, 1 = Yes

ICON_OVERLAY_ASSETS_BUNDLE="" #Path to .xcassets
TAB_USE_TIME_FOR_BUILD_NUMBER= #Use Time and date for build number or BUILD_NUMBER environment variable (created by Jenkins or Team City) true = use time, false = use BUILD_NUMBER

ITUNES_CONNECT_USERNAME="" #iTunes Connect login (usually email address)
ITUNES_CONNECT_TEAM_ID="" #The ID of your iTunes Connect team if you're in multiple teams https://github.com/fastlane/fastlane/issues/4301#issuecomment-253461017
ITUNES_CONNECT_PROVIDER="" #The provider short name to be used with the iTMSTransporter to identify your team
EOF
}

function make_custom_env_file {
  env=$1
  cat > .env.$env <<EOF
#This is your ${env} environment file
#Set environment variables used in ${env} builds here
GYM_SCHEME="" #Scheme name
FL_UPDATE_PLIST_APP_IDENTIFIER="" #App Bundle Identifier
FL_UPDATE_PLIST_DISPLAY_NAME="" #Display name of app
EOF
}

make_default_env_file
make_custom_env_file "test"
make_custom_env_file "uat"
make_custom_env_file "staging"
make_custom_env_file "prod"
