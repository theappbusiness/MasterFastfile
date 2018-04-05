require 'fastimage'
module Fastlane
  module Actions
    module SharedValues
      ICON_OVERLAY_SOURCE_PATH = :ICON_OVERLAY_SOURCE_PATH
      ICON_OVERLAY_ASSETS_BUNDLE = :ICON_OVERLAY_ASSETS_BUNDLE
      ICON_OVERLAY_APP_VERSION = :ICON_OVERLAY_APP_VERSION
    end

    class IconOverlayAction < Action
      def self.run(params)
        source_path = ENV['ICON_OVERLAY_SOURCE_PATH']
        assets_path = ENV['ICON_OVERLAY_ASSETS_BUNDLE']
        if source_path.to_s.empty? && assets_path.to_s.empty?
          puts 'Skipping icon overlay'
          return
        end
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        ENV['ICON_OVERLAY_APP_VERSION'] = params[:version].to_s
        overlay
      end

      def self.icon_size(path)
        FastImage.size(path)
      end

      def self.caption
        version = ENV['ICON_OVERLAY_APP_VERSION']
        commit = `git rev-parse HEAD | head -1`.strip
        time = Time.new
        scheme = ENV['ICON_OVERLAY_TITLE'] || ENV['GYM_SCHEME'] || 'scheme'
        [
          "#{version} #{scheme}",
          "#{time.day}/#{time.month} #{time.hour}:#{time.min}",
          commit[0..7].to_s
        ].join("\n")
      end

      def self.convert(source_path, destination_path) # rubocop:disable Metrics/AbcSize
        if !File.exist? source_path
          throw "Source path of #{source_path} does not exist for image conversion"
        elsif !File.exist? destination_path
          throw "Destination path of #{destination_path} does not exist for image conversion"
        end

        icon_size = self.icon_size source_path
        command = [
          'convert',
          '-background "#0008"',
          '-fill white',
          '-gravity center',
          "-size #{icon_size[0]}x#{icon_size[1] * 0.7}",
          "caption:\"#{caption}\"",
          "\"#{source_path}\"",
          '+swap -gravity center -composite',
          "\"#{destination_path}\""
        ].join(' ')
        puts command.cyan
        system command
      end

      def self.source_icons_directory
        if !ENV['ICON_OVERLAY_SOURCE_PATH'].to_s.empty?
          File.expand_path(source_path)
        elsif !ENV['ICON_OVERLAY_ASSETS_BUNDLE'].to_s.empty?
          File.expand_path(File.join(ENV['ICON_OVERLAY_ASSETS_BUNDLE'], 'AppIcon.appiconset'))
        else
          ENV['ICON_OVERLAY_SOURCE_PATH']
        end
      end

      def self.destination_icons_directory
        if !ENV['ICON_OVERLAY_ASSETS_BUNDLE'].to_s.empty?
          File.expand_path(File.join(ENV['ICON_OVERLAY_ASSETS_BUNDLE'], 'AppIcon.appiconset'))
        else
          File.expand_path(ENV['ICON_OVERLAY_SOURCE_PATH'])
        end
      end

      def self.destination_for_source_path(source_path)
        filename = File.basename source_path
        File.join(destination_icons_directory, filename)
      end

      def self.overlay
        icons_dir = source_icons_directory
        source_path_error = "Source path for icons directory #{icons_dir} does not exist for image conversion"
        throw source_path_error unless Dir.exist?(icons_dir)
        Dir.glob File.join(icons_dir, '*.png') do |source|
          destination = destination_for_source_path source
          convert(source, destination)
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Adds image overlay containing App version time and date'
      end

      def self.details
        'Adds image overlay containing App version time and date'
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :version,
                                       env_name: 'ICON_OVERLAY_APP_VERSION',
                                       description: 'App version number to overlay on icon',
                                       verify_block: proc do |value|
                                         raise 'No app version number pass using `version`'.red unless value && !value.empty?
                                       end)
        ]
      end

      def self.output
        []
      end

      def self.authors
        ['TAB, @TheAppBusiness']
      end

      def self.is_supported?(_) # rubocop:disable Naming/PredicateName, Naming/UncommunicativeMethodParamName
        platform == :ios
      end
    end
  end
end
