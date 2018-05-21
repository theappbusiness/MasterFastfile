module Fastlane
  module Actions
    class InstallProvisioningProfilesAction < Action
      def self.run(_) # rubocop:disable Naming/UncommunicativeMethodParamName
        profile_paths = Dir.glob('./**/*.mobileprovision')
        if profile_paths.empty?
          UI.message('Skipping installing provisioning profiles since no profiles were found.')
        else
          profile_paths.each do |path|
            uuid = `grep UUID -A1 -a #{path} | grep -io \"[-A-Z0-9]\\{36\\}\"`
            destination = "#{ENV['HOME']}/Library/MobileDevice/Provisioning Profiles/#{uuid.strip}.mobileprovision"
            begin
              FileUtils.cp(path, destination)
            rescue # rubocop:disable Style/RescueStandardError
              UI.important("Failed to install profile at path #{path} to #{destination}")
            else
              UI.success("Installed profile at path #{path} successfully to #{destination}")
            end
          end
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Installs all local provisioning profiles contained within the directory this action is run in.'
      end

      def self.available_options
        []
      end

      def self.authors
        [
          'Luciano Marisi @lucianomarisi',
          'Kane Cheshire @KaneCheshire'
        ]
      end

      def self.is_supported?(_) # rubocop:disable Naming/PredicateName, Naming/UncommunicativeMethodParamName
        true
      end
    end
  end
end
