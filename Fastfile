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
    set_build_number()
    gym(use_legacy_build_api: true)
    hockey(notes_type: "0", notes: create_change_log())
  end

  lane :hockey_no_test do
    setup()
    version_number = get_version_number
    icon_overlay(version: version_number)
    set_build_number()
    gym(use_legacy_build_api: true)
    hockey(notes_type: "0", notes: create_change_log())
  end

  def setup()
    ENV['SCAN_SCHEME'] = ENV['GYM_SCHEME']
    ENV['SCAN_DEVICE'] = "iPhone 6 (9.2)"
    if is_ci
      xcode_select(ENV['XCODE_PATH'])
    end
  end

  def set_build_number()
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

  def create_change_log()
    cmd = "git log --after={1.day.ago} --pretty=format:'%an%x09%h%x09%cd%x09%s' --date=relative"
    output = `#{cmd}`
    return (output.length == 0) ? "No Changes" : output
  end

  after_all do |lane|
  end

  error do |lane, exception|
  end
