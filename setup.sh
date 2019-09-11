#!/bin/bash

mkdir fastlane
cd fastlane
echo "app_identifier = ENV['FL_UPDATE_PLIST_APP_IDENTIFIER']" > Appfile
echo "fastlane_version \"2.86.0\"
import_from_git(url: 'https://github.com/theappbusiness/MasterFastfile.git', path: 'Fastfile')" > Fastfile

function make_default_env_file {
  cat > .env.default <<EOF
#This is your default environment file
#Set environment variables used in all builds here
#More information on available environment variables can be found here https://github.com/theappbusiness/MasterFastfile/wiki/Quick-simple-setup-using-TAB-defaults

GYM_EXPORT_OPTIONS="" # Path to export options plist
GYM_CODE_SIGNING_IDENTITY=""" #Code Sign Identity

FL_PROJECT_SIGNING_PROJECT_PATH="" # Path to xcode project to sign
FL_UPDATE_PLIST_PATH="" #Path to Info.plist of application
FL_SLACK_CHANNEL= #Slack channel to post build results to

SCAN_DEVICE="iPhone SE (11.4)"
SCAN_SLACK_CHANNEL="" #Slack channel to post test run info to

TAB_PROVISIONING_PROFILE="" #The name of the provisioning profile to use.
TAB_PROVISIONING_PROFILE_PATH="" #Path to the provisioning profile to install.
TAB_PRIMARY_TARGET="" #Main app target name
TAB_XCODE_PATH="" #Path to required xcode
TAB_UI_TEST_DEVICES="iPhone X (11.4)"
TAB_UI_TEST_SCHEME="" #Scheme to use for running UITests
TAB_SLACK_WEBHOOK_URL="" #Slack webhook for posting build information

ICON_OVERLAY_ASSETS_BUNDLE="" #Path to .xcassets containing AppIcon. If this variable exists build info will be added to the app icon

APPCENTER_API_TOKEN="" #Used to upload builds to app center
APPCENTER_OWNER_NAME=""  # when you're on your organization's page in AppCenter, this is the part of the URL slug after `orgs`: `https://appcenter.ms/orgs/<owner_name>/applications`

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

APPCENTER_APP_NAME="" #Name of the application in app center
APPCENTER_DISTRIBUTE_DESTINATIONS="" #Distribution groups to give access to this app
APPCENTER_DISTRIBUTE_NOTIFY_TESTERS="" #Set to true to email testers about new build.
EOF
}

make_default_env_file
make_custom_env_file "test"
make_custom_env_file "uat"
make_custom_env_file "staging"
make_custom_env_file "prod"
