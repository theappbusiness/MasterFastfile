![The App Business](https://github.com/theappbusiness/MasterFastfile/blob/master/MasterFastfile.png)

# MasterFastfile
 To setup your project to use the TAB master fastfile navigate to your project route and run the following command

 ```
$ curl https://raw.githubusercontent.com/theappbusiness/MasterFastfile/master/setup.sh | sh
```

Then setup your environments using the `.env` files created for you. Several non project specific variables are already set, to complete the process just add the missing variable values.

 In the `default.env` add values for the following parameters
* FL_UPDATE_PLIST_PATH - Path to Info.plist
* FL_HOCKEY_NOTIFY - Email team when new build available?
  * 0 = No
  * 1 = Yes
* ICON_OVERLAY_ASSETS_BUNDLE - Path to .xcassets
* TAB_USE_TIME_FOR_BUILD_NUMBER - Use Time and date for build number or BUILD_NUMBER environment variable (created by jenkis or team city)
  * true = Use time and date
  * false = Use BUILD_NUMBER

In the `.env` file for each environment add values for the following parameters

* GYM_SCHEME - Scheme to build for the current environment.
* FL_UPDATE_PLIST_APP_IDENTIFIER - App Bundle Identifier
* FL_UPDATE_PLIST_DISPLAY_NAME - Display name of app


## Available lanes

* test
    * runs tests
* hockey
    * runs tests
    * sets build number
    * adds build info to app icon
    * builds and archives project
    * generates changelog from git commits
    * uploads app to hockey
* hockey_no_test
    * sets build number
    * adds build info to app icon
    * builds and archives project
    * generates changelog from git commits
    * uploads app to hockey

## Custom Actions
* icon_overlay
  * Adds overlay to app icon containing build information

For more detailed information on how to setup your project and environment please see our [wiki](https://github.com/theappbusiness/MasterFastfile/wiki)
