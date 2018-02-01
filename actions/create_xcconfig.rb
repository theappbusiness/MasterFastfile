module Fastlane
  module Actions
    module SharedValues
      INSTALL_PROVISIONING_PROFILE_CUSTOM_VALUE = :INSTALL_PROVISIONING_PROFILE_CUSTOM_VALUE
    end

    class CreateXcconfigAction < Action
      def self.run(params)
        filename = params[:filename]
        project = Xcodeproj::Project.open(ENV['FL_PROJECT_SIGNING_PROJECT_PATH'])
        lines = []
        project.targets.each do |target|
          profile = self.get_profile_for_target(target)
          if !profile.nil?
            lines.push("#{target.name}_PROFILE_SPECIFIER=#{profile}")
          end
        end
        lines.push("PROVISIONING_PROFILE_SPECIFIER=$($(TARGET_NAME)_PROFILE_SPECIFIER)")
        begin
          File.write(filename, lines.join("\n"))
        rescue => exception
          UI.error(exception)
        else
          UI.success("Successfully created #{filename}")
        end

      end

      def self.get_profile_for_target(target)
        config = target.build_configurations.first
        bundleID = config.build_settings['PRODUCT_BUNDLE_IDENTIFIER']
        profilesHash = GetInfoPlistValueAction.run(path: ENV['GYM_EXPORT_OPTIONS'], key: "provisioningProfiles")
        profilesHash[bundleID]
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Creates an xcconfig file for provisioning"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :filename,
                                       env_name: "TAB_XCCONFIG_FILENAME",
                                       description: "The name of the xcconfig to create",
                                       is_string: true,
                                       default_value: "TAB.release.xcconfig")
        ]
      end

      def self.authors
        [
          "Kane Cheshire ✨ @KaneCheshire"
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
