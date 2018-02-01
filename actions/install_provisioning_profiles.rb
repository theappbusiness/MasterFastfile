module Fastlane
  module Actions
    module SharedValues
    end

    class InstallProvisioningProfilesAction < Action
      def self.run(params)
        profile_paths = Dir.glob("./**/*.mobileprovision")
        if profile_paths.empty?
          UI.message("Skipping installing provisioning profiles since no profiles were found.")
        else
          profile_paths.each do |path|
            uuid = `grep UUID -A1 -a #{path} | grep -io \"[-A-Z0-9]\\{36\\}\"`
            destination = "#{ENV['HOME']}/Library/MobileDevice/Provisioning\\\ Profiles/#{uuid.strip}.mobileprovision"
            `cp #{path} #{destination}`
            UI.success("Installed profile at path #{path} successfully")
          end
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Installs all local provisioning profiles contained within the directory this action is run in."
      end

      def self.available_options
        []
      end

      def self.authors
        [
          "Luciano Marisi @lucianomarisi",
          "Kane Cheshire @KaneCheshire"
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
