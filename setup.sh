#!/bin/bash

mkdir fastlane
cd fastlane
echo "app_identifier = ENV['APP_ID']" > Appfile
echo "fastlane_version \"1.55.0\"
import_from_git(url: 'git@bitbucket.org:theappbusiness/tabfastlanemaster-ios.git', path: 'Fastfile')" > Fastfile
echo "#This is your default environment file
#Set environment variables used in all builds here" > .env.default
echo "#This is your test environment file
#Set environment variables used in test builds here" > .env.test
echo "#This is your uat environment file
#Set environment variables used in uat builds here" > .env.uat
echo "#This is your stage environment file
#Set environment variables used in stage builds here" > .env.stage
echo "#This is your prod environment file
#Set environment variables used in prod builds here" > .env.prod
