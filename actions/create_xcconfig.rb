module Fastlane
  module Actions
    class CreateXcconfigAction < Action
      def self.run(params)
        filename = params[:filename]
        project = Xcodeproj::Project.open(ENV['FL_PROJECT_SIGNING_PROJECT_PATH'])
        lines = []
        project.targets.each do |target|
          profile = get_profile_for_target(target)
          lines.push("#{target.name}_PROFILE_SPECIFIER=#{profile}") unless profile.nil?
        end
        lines.push('PROVISIONING_PROFILE_SPECIFIER=$($(TARGET_NAME)_PROFILE_SPECIFIER)')
        begin
          File.write(filename, lines.join("\n"))
        rescue => exception # rubocop:disable Style/RescueStandardError
          UI.error(exception)
        else
          UI.success("Successfully created #{filename}")
        end
      end

      def self.get_profile_for_target(target)
        config = target.build_configurations.first
        bundle_id = config.build_settings['PRODUCT_BUNDLE_IDENTIFIER']
        profiles_hash = GetInfoPlistValueAction.run(path: ENV['GYM_EXPORT_OPTIONS'], key: 'provisioningProfiles')
        profiles_hash[bundle_id]
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Creates an xcconfig file for provisioning'
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :filename,
                                       env_name: 'TAB_XCCONFIG_FILENAME',
                                       description: 'The name of the xcconfig to create',
                                       is_string: true,
                                       default_value: 'TAB.release.xcconfig')
        ]
      end

      def self.authors
        [
          'Kane Cheshire ✨ @KaneCheshire'
        ]
      end

      def self.is_supported?(_) # rubocop:disable Naming/PredicateName, Naming/UncommunicativeMethodParamName
        true
      end
    end
  end
end
