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
    icon_overlay(version: get_version_number)
    setBuildNumber()
    gym(use_legacy_build_api: true)
    hockey
  end

  lane :hockey_no_test do
    setup()
    version_number = get_version_number
    icon_overlay(version: version_number)
    setBuildNumber()
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

  def setBuildNumber()
    build_number = "0"
    use_timestamp = ENV['TAB_USE_TIME_FOR_BUILD_NUMBER'] || false
    if use_timestamp
      time = Time.new
      build_number = "#{time.year}#{time.month}#{time.day}#{time.hour}#{time.min}#{time.sec}"
    else
      build_number = ENV['BUILD_NUMBER']
    end
    increment_build_number(build_number: build_number)
  end

  after_all do |lane|
  end

  error do |lane, exception|
  end
