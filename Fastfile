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
    increment_build_number
    gym(use_legacy_build_api: true)
    hockey
    commit_version_bump
    push_to_git_remote
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
