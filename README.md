![The App Business](https://github.com/theappbusiness/MasterFastfile/blob/master/MasterFastfile.png)

# MasterFastfile

To setup your project to use the TAB MasterFastfile, navigate to your project root and run the following command:

```
curl https://raw.githubusercontent.com/theappbusiness/MasterFastfile/master/setup.sh | sh
```

Then setup your environments using the `.env` files created for you. To complete the setup just add the missing variable values.

To use the MasterFastfile add the following command to your Fastfile

```
import_from_git(url: 'https://github.com/theappbusiness/MasterFastfile.git', branch: '1.5.0', path: 'Fastfile')
```
For more detailed instructions [see our wiki](https://github.com/theappbusiness/MasterFastfile/wiki)

## Available lanes

* test
    * runs tests
* deploy_to_hockey
    * runs tests
    * sets build number
    * adds build info to app icon
    * builds and archives project
    * generates changelog from git commits
    * uploads app to hockey
* deploy_to_hockey_no_test
    * sets build number
    * adds build info to app icon
    * builds and archives project
    * generates changelog from git commits
    * uploads app to hockey
* deploy_to_test_flight (How do I find my iTunes Connect team ID? [link](https://github.com/fastlane/fastlane/issues/4301#issuecomment-253461017))
    * runs tests
    * sets build number
    * adds build info to app icon
    * builds and archives project
    * uploads app to test flight
* local_build
	  * optionally adds icon overlay: e.g. `fastlane local_build icon_overlay:true`
	  * builds an ipa

## Custom Actions
* icon_overlay
  * Adds overlay to app icon containing build information

For more detailed information on how to setup your project and environment please see our [wiki](https://github.com/theappbusiness/MasterFastfile/wiki)

## Dependencies

### Imagemagick
Install using brew
```
brew install imagemagick
```
### Ghostscript
Install using brew
```
brew install ghostscript
```
