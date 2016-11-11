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

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :development,
                                       env_name: "TAB_PROVISIONING_PROFILE_PATH",
                                       description: "The path of the provisioning profile to install",
                                       is_optional: false,
                                       is_string: false, # true: verifies the input is a string, false: every kind of value
                                       default_value: false) # the default value if the user didn't provide one
        ]
      end

      def self.authors
        ["Luciano Marisi @lucianomarisi"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
