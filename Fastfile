fastlane_version "1.55.0"

default_platform :ios

  before_all do
    if ENV['SLACK_URL'] == nil
      ENV['SLACK_URL'] = ENV['TAB_SLACK_WEBHOOK_URL']
    end
  end

  lane :debug do
    _parse_provision_file()
  end


  lane :test do
    _setup()
    skip_slack = ENV['SCAN_SLACK_CHANNEL'].to_s.strip.empty?
    scan(skip_slack: skip_slack)
  end

  lane :deploy_to_hockey do
    _setup()
    scan
    _buildAndDeployToHockey()
  end

  lane :deploy_to_hockey_no_test do
    _setup()
    _buildAndDeployToHockey()
  end

  lane :local_build do |options|
      if options[:icon_overlay]
        icon_overlay(version: get_version_number)
      end
      _build_ipa()
  end

  def _buildAndDeployToHockey()
    icon_overlay(version: get_version_number)
    _set_build_number()
    _build_ipa()
    _upload_to_hockey()
  end

  def _build_ipa()
    update_app_identifier(xcodeproj: ENV['FL_UPDATE_PLIST_PROJECT_PATH'],
                         plist_path: ENV['FL_UPDATE_PLIST_PATH'],
                     app_identifier: ENV['FL_UPDATE_PLIST_APP_IDENTIFIER'] )
    update_info_plist
    _build_with_gym()
  end

  def _build_with_gym()
    install_provisioning_profile
    _update_team_id_if_necessary
    provisioning_profile_name = ENV['TAB_PROVISIONING_PROFILE']
    # Default export method is enterprise since this is the most commonly used
    export_method = "enterprise"
    xcconfig_filename = Dir.pwd + "/TAB.release.xcconfig"
    if ENV['TAB_EXPORT_METHOD'] != nil
      export_method = ENV['TAB_EXPORT_METHOD']
    else
      UI.message("Fallbacking to enterprise export_method sinceTAB_EXPORT_METHOD is not defined")
    end
    if File.file?("Provfile")
      _parse_provision_file()
      gym(use_legacy_build_api: true, xcconfig: xcconfig_filename)
    elsif provisioning_profile_name != nil
      File.write(xcconfig_filename, "PROVISIONING_PROFILE_SPECIFIER = #{provisioning_profile_name}\n")
      gym(export_method: export_method, xcconfig: xcconfig_filename)
    else
      gym(export_method: export_method)
    end
  end

  def _upload_to_hockey()
    custom_notes = ENV['TAB_HOCKEY_RELEASE_NOTES'] || ""
    notes = custom_notes == "" ? _create_change_log() : custom_notes
    hockey(notes_type: "0", notes: notes)
  end

  def _notify_slack()
    if ENV['FL_SLACK_CHANNEL'].to_s.strip.empty?
      return
    end
    hockey_download_url = lane_context[SharedValues::HOCKEY_DOWNLOAD_LINK]
    if hockey_download_url != nil
      new_build_message = "A new build is available on <" + hockey_download_url + "|hockey>"
      slack(message: new_build_message)
    else
      slack()
    end
  end

  def _setup()
    ENV['SCAN_SCHEME'] = ENV['GYM_SCHEME']
    if ENV['SCAN_DEVICE'] == nil
      ENV['SCAN_DEVICE'] = "iPhone 6 (9.3)"
    end
    if is_ci && ENV['TAB_XCODE_PATH'] != nil
      xcode_select(ENV['TAB_XCODE_PATH'])
    end
  end

  def _set_build_number()
    build_number = "0"
    use_timestamp = ENV['TAB_USE_TIME_FOR_BUILD_NUMBER'] || false
    if use_timestamp
      build_number = Time.now.strftime("%y%m%d%H%M")
    else
      build_number = ENV['BUILD_NUMBER']
    end
    increment_build_number(build_number: build_number)
  end

  def _create_change_log()
    cmd = "git log --after={1.day.ago} --pretty=format:'%an%x09%h%x09%cd%x09%s' --date=relative"
    output = `#{cmd}`
    return (output.length == 0) ? "No Changes" : output
  end

  def _update_team_id_if_necessary()
    if !ENV['FL_PROJECT_SIGNING_PROJECT_PATH'].to_s.strip.empty? && !ENV['FL_PROJECT_TEAM_ID'].to_s.strip.empty?
      update_project_team
    end
  end

  def _parse_provision_file()
    sh 'RUBYSCRIPT="$(echo \'def target(targetName, &doBlock)
      profileName = doBlock.call
      print targetName + "_" + "PROVISIONING_PROFILE=\"" + profileName + "\"\n"
    end
    \' & cat ProvFile)"
    echo "${RUBYSCRIPT}" | ruby > TAB.release.xcconfig
    echo \'PROVISIONING_PROFILE_SPECIFIER=$($(WRAPPER_NAME)_PROVISIONING_PROFILE)\' >> TAB.release.xcconfig'
  end

  after_all do |lane|
    _notify_slack()
  end

  error do |lane, exception|
  end
