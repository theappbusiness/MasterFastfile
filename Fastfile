fastlane_version "1.55.0"

default_platform :ios

  before_all do
  end

  lane :test do |options|
    setupScan()
    scan
  end

  lane :hockey do
    setupScan()
    scan
    gym(use_legacy_build_api: true)
    hockey
  end

  def setupScan()
  puts ENV['GYM_SCHEME']
    ENV['SCAN_SCHEME'] = ENV['GYM_SCHEME']
    ENV['SCAN_DEVICE'] = "iPhone 6 (9.2)"
    puts "in setup scan"
  end

  after_all do |lane|
  end

  error do |lane, exception|
  end
