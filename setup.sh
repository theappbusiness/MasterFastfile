#!/bin/bash

mkdir fastlane
cd fastlane
echo "app_identifier = ENV['FL_UPDATE_PLIST_APP_IDENTIFIER']" > Appfile
echo "fastlane_version \"1.55.0\"
import_from_git(url: 'git@bitbucket.org:theappbusiness/tabfastlanemaster-ios.git', path: 'Fastfile')" > Fastfile
echo "#This is your default environment file
#Set environment variables used in all builds here
FL_HOCKEY_API_TOKEN=f99b82982b164abaa5963c5caa09ec1e
FL_HOCKEY_OWNER_ID=467137
FL_UPDATE_PLIST_PATH= #Path to Info.plist
GYM_CODE_SIGNING_IDENTITY=\"iPhone Distribution: The App Business LTD\"
FL_HOCKEY_TEAMS=\"23022\"
FL_HOCKEY_NOTIFY= #Email team when new build avialable? 0 = No, 1 = Yes
ICON_OVERLAY_ASSETS_BUNDLE= #Path to .xcassets
TAB_USE_TIME_FOR_BUILD_NUMBER= #Use Time and date for build number or BUILD_NUMBER environment variable (created by jenkis or team city) true = use time, false = use BUILD_NUMBER" > .env.default
echo "#This is your test environment file
#Set environment variables used in test builds here
GYM_SCHEME= #Scheme name
FL_UPDATE_PLIST_APP_IDENTIFIER= #App Bundle Identifier
FL_UPDATE_PLIST_DISPLAY_NAME= #Display name of app" > .env.test
echo "#This is your uat environment file
#Set environment variables used in uat builds here
GYM_SCHEME= #Scheme name
FL_UPDATE_PLIST_APP_IDENTIFIER= #App Bundle Identifier
FL_UPDATE_PLIST_DISPLAY_NAME= #Display name of app" > .env.uat
echo "#This is your stage environment file
#Set environment variables used in stage builds here
GYM_SCHEME= #Scheme name
FL_UPDATE_PLIST_APP_IDENTIFIER= #App Bundle Identifier
FL_UPDATE_PLIST_DISPLAY_NAME= #Display name of app" > .env.stage
echo "#This is your prod environment file
#Set environment variables used in prod builds here
GYM_SCHEME= #Scheme name
FL_UPDATE_PLIST_APP_IDENTIFIER= #App Bundle Identifier
FL_UPDATE_PLIST_DISPLAY_NAME= #Display name of app" > .env.prod
