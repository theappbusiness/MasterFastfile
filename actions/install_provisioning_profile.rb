module Fastlane
  module Actions
    module SharedValues
      INSTALL_PROVISIONING_PROFILE_CUSTOM_VALUE = :INSTALL_PROVISIONING_PROFILE_CUSTOM_VALUE
    end

    class InstallProvisioningProfileAction < Action
      def self.run(params)
        if ENV['TAB_PROVISIONING_PROFILE_PATH'] != nil
          provisioning_profile_path=ENV['TAB_PROVISIONING_PROFILE_PATH']
          provisioning_profile_uuid = `grep UUID -A1 -a #{provisioning_profile_path} | grep -io \"[-A-Z0-9]\\{36\\}\"`
          provisioning_profile_destination = "#{ENV['HOME']}/Library/MobileDevice/Provisioning\\\ Profiles/#{provisioning_profile_uuid.strip}.mobileprovision"
          `cp #{provisioning_profile_path} #{provisioning_profile_destination}`
          UI.success("Installed profile at path #{params[:provisioning_profile_path]} succesfully")
        else 
          UI.message("Skipping installing provisioning profile since TAB_PROVISIONING_PROFILE_PATH is not defined")
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
          FastlaneCore::ConfigItem.new(key: :provisioning_profile_path,
                                       env_name: "TAB_PROVISIONING_PROFILE_PATH",
                                       description: "The path of the provisioning profile to install",
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
