fastlane_version "1.55.0"

default_platform :ios

  before_all do
  end

  lane :test do
    setup()
    scan
  end

  lane :hockey do
    setup()
    scan
    version_number = get_version_number
    icon_overlay(version: version_number)
    gym(use_legacy_build_api: true)
    hockey
  end

  lane :hockey_no_test do
    setup()
    version_number = get_version_number
    icon_overlay(version: version_number)
    gym(use_legacy_build_api: true)
    hockey
  end

  def setup()
    ENV['SCAN_SCHEME'] = ENV['GYM_SCHEME']
    ENV['SCAN_DEVICE'] = "iPhone 6 (9.2)"
    if is_ci
      xcode_select(ENV['XCODE_PATH'])
    end
  end

  after_all do |lane|
  end

  error do |lane, exception|
  end
