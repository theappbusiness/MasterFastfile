require 'fastimage'
module Fastlane
  module Actions
    module SharedValues
      ICON_OVERLAY_SOURCE_PATH = :ICON_OVERLAY_SOURCE_PATH
      ICON_OVERLAY_ASSETS_BUNDLE = :ICON_OVERLAY_ASSETS_BUNDLE
      ICON_OVERLAY_APP_VERSION = :ICON_OVERLAY_APP_VERSION
    end

    # To share this integration with the other fastlane users:
    # - Fork https://github.com/fastlane/fastlane
    # - Clone the forked repository
    # - Move this integration into lib/fastlane/actions
    # - Commit, push and submit the pull request

    class IconOverlayAction < Action
      def self.run(params)
        source_path = ENV['ICON_OVERLAY_SOURCE_PATH']
        assets_path = ENV['ICON_OVERLAY_ASSETS_BUNDLE']
        if source_path.to_s.empty? && assets_path.to_s.empty?
          puts "Skipping icon overlay"
          return
        end
        
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        ENV['ICON_OVERLAY_APP_VERSION'] = "#{params[:version]}"
        overlay()

        # sh "shellcommand ./path"

        # Actions.lane_context[SharedValues::ICON_OVERLAY_CUSTOM_VALUE] = "my_val"
      end

      def self.icon_size(path)
        FastImage.size(path)
      end

      def self.caption
        version = ENV['ICON_OVERLAY_APP_VERSION']
        commit = `git rev-parse HEAD | head -1`.strip
        time = Time.new
        scheme = ENV['ICON_OVERLAY_TITLE'] || ENV['GYM_SCHEME'] || "scheme"
        ["#{version} #{scheme}",
         "#{time.day}/#{time.month} #{time.hour}:#{time.min}",
         "#{commit[0..7]}"
        ].join("\n")
      end

      def self.convert(source_path, destination_path)
        if not File.exists? source_path
          throw "Source path of #{source_path} does not exist for image conversion"
        elsif not File.exists? destination_path
          throw "Destination path of #{destination_path} does not exist for image conversion"
        end

        icon_size = self.icon_size source_path
        command = ["convert",
          "-background \"#0008\"",
          "-fill white",
          "-gravity center",
          "-size #{icon_size[0]}x#{icon_size[1] * 0.7}",
          "caption:\"#{self.caption}\"",
          "\"#{source_path}\"",
          "+swap -gravity center -composite",
          "\"#{destination_path}\""
        ].join(" ")
        puts command.cyan
        system command
      end

      def self.source_icons_directory
        source_path = ENV['ICON_OVERLAY_SOURCE_PATH']
        if source_path
          source_path = File.expand_path(source_path)
        else
          source_path = File.expand_path(File.join(ENV['ICON_OVERLAY_ASSETS_BUNDLE'], 'AppIcon.appiconset')) if ENV['ICON_OVERLAY_ASSETS_BUNDLE']
        end
        source_path
      end

      def self.destination_icons_directory
        destination_path = ENV['ICON_OVERLAY_ASSETS_BUNDLE']
        if destination_path
          destination_path = File.expand_path(File.join(destination_path, 'AppIcon.appiconset'))
        else
          destination_path = File.expand_path(ENV['ICON_OVERLAY_SOURCE_PATH'])
        end
        destination_path
      end

      def self.destination_for_source_path(source_path)
        filename = File.basename source_path
        File.join(self.destination_icons_directory, filename)
      end

      def self.overlay
        icons_dir = self.source_icons_directory
        if !Dir.exists?(icons_dir)
          throw "Source path for icons directory #{icons_dir} does not exist for image conversion"
        end

        Dir.glob File.join(icons_dir, "*.png") do |source|
          destination = self.destination_for_source_path source
          self.convert(source, destination)
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Adds image overlay containing App version time and date"
      end

      def self.details
        "Adds image overlay containing App version time and date"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :version,
                                       env_name: "ICON_OVERLAY_APP_VERSION", # The name of the environment variable
                                       description: "App version number to overlay on icon", # a short description of this parameter
                                       verify_block: proc do |value|
                                          raise "No app version number pass using `version`".red unless (value and not value.empty?)
                                          # raise "Couldn't find file at path '#{value}'".red unless File.exist?(value)
                                       end)
        ]
      end

      def self.output
        []
      end

      def self.return_value
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["Your GitHub/Twitter Name"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
