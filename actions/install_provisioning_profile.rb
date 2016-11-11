module Fastlane
  module Actions
    module SharedValues
      INSTALL_PROVISIONING_PROFILE_CUSTOM_VALUE = :INSTALL_PROVISIONING_PROFILE_CUSTOM_VALUE
    end

    class InstallProvisioningProfileAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        UI.message "Parameter API Token: #{params[:api_token]}"
        if ENV['TAB_PROVISIONING_PROFILE_PATH'] != nil
          provisioning_profile_path="../#{ENV['TAB_PROVISIONING_PROFILE_PATH']}" # needed because fastlane runs in the fastlane directory
          provisioning_profile_uuid = `grep UUID -A1 -a #{provisioning_profile_path} | grep -io \"[-A-Z0-9]\\{36\\}\"`
          provisioning_profile_destination = "#{ENV['HOME']}/Library/MobileDevice/Provisioning\\\ Profiles/#{provisioning_profile_uuid.strip}.mobileprovision"
          `cp #{provisioning_profile_path} #{provisioning_profile_destination}`
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Installs a provisioning profile from a path"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        # "You can use this action to do cool things..."
      end

      def self.available_options
        # Define all options your action supports. 
        
        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :development,
                                       env_name: "TAB_PROVISIONING_PROFILE_PATH",
                                       description: "The path of the provisioning profile to install",
                                       is_string: false, # true: verifies the input is a string, false: every kind of value
                                       default_value: false) # the default value if the user didn't provide one
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        # [
        #   ['INSTALL_PROVISIONING_PROFILE_CUSTOM_VALUE', 'A description of what this value contains']
        # ]
      end

      def self.return_value
        # If you method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["Luciano Marisi @lucianomarisi"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
