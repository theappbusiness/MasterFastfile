fastlane_version '2.86.0'
default_platform :ios

# --------- Before any lane runs --------- #

before_all do
  ENV['SLACK_URL'] ||= ENV['TAB_SLACK_WEBHOOK_URL']
end

# --------- Custom lanes --------- #

desc 'Runs all unit tests that are included in the scheme.'
desc 'It\'s not recommended to include UI tests in this scheme, instead run the "ui_test" lane.'
lane :test do
  _setup
  skip_slack = ENV['SCAN_SLACK_CHANNEL'].to_s.strip.empty?
  scan(
    skip_slack: skip_slack,
    devices: ENV['TAB_UNIT_TEST_DEVICE'] || ['iPhone 8']
  )
end

desc 'Runs UI tests that are included in the scheme.'
desc 'Environment variables to use: `TAB_UI_TEST_DEVICES`, `TAB_REPORT_FORMATS`, `TAB_UI_TEST_SCHEME`'
lane :ui_test do
  _setup
  skip_slack = ENV['SCAN_SLACK_CHANNEL'].to_s.strip.empty?

  max_test_try_count = (ENV['MULTI_SCAN_TRY_COUNT'] || "1").to_i
  test_run_block = lambda do |testrun_info|
    failed_test_count = testrun_info[:failed].size

    if failed_test_count > 0
      try_attempt = testrun_info[:try_count]
      if try_attempt < max_test_try_count
        UI.header('Not all UI tests have passed. Attempting re-run of failed...')
      else
        UI.important('Not all UI tests have passed and the maximum try count has been reached.')
      end
    end
    UI.message("Attempt #{testrun_info[:try_count]} out of #{max_test_try_count} run info: #{testrun_info}")

  end

  result = multi_scan(
    skip_slack: skip_slack,
    devices: ENV['TAB_UI_TEST_DEVICES'].split(':'),
    output_types: ENV['TAB_REPORT_FORMATS'],
    scheme: ENV['TAB_UI_TEST_SCHEME'],
    try_count: max_test_try_count,
    fail_build: true,
    testrun_completed_block: test_run_block,
    parallel_testrun_count: (ENV['MULTI_SCAN_PARALLEL_WORKER_COUNT'] || "4").to_i
  )
  unless result[:failed_testcount].zero?
    UI.message("There are #{result[:failed_testcount]} legitimate failing tests")
  end
end

desc 'Runs all unit tests before deploying to App Center.'
lane :deploy_to_app_center do
  _setup
  scan
  _build_and_deploy_to_app_center
end

desc 'Deploys to App Center without running any tests.'
lane :deploy_to_app_center_no_test do
  _setup
  _build_and_deploy_to_app_center
end

desc 'Runs all unit tests before deploying to TestFlight.'
lane :deploy_to_test_flight do
  if _get_export_method == 'app-store'
    _setup
    scan
    _set_build_number
    _build_ipa
    _upload_to_test_flight
  else
    UI.message('Deploy to TestFlight failed. Uploading to iTunes Connect only supports `app-store` export method.')
  end
end

desc 'Creates a local IPA build without running any tests.'
lane :local_build do |options|
  icon_overlay(version: _get_project_build_number) if options[:icon_overlay]
  _build_ipa
end

# --------- After all lanes have run --------- #

after_all do
  _notify_slack
end

# --------- Error handling --------- #

error do |lane, exception|
end

# --------- Custom functions --------- #

def _setup
  ENV['SCAN_SCHEME'] = ENV['GYM_SCHEME']
  xcode_select(ENV['TAB_XCODE_PATH']) if is_ci && !ENV['TAB_XCODE_PATH'].nil?

  unless ENV['TAB_UI_TEST_SCHEME'].nil? # rubocop:disable Style/GuardClause
    ENV['TAB_REPORT_FORMATS'] = 'html' if ENV['TAB_REPORT_FORMATS'].nil?
    ENV['TAB_UI_TEST_DEVICES'] ||= ['iPhone 8']
  end
end

def _build_and_deploy_to_app_center
  icon_overlay(version: _get_project_build_number)
  _set_build_number
  _build_ipa
  _upload_to_app_center
end

def _build_number
  use_timestamp = ENV['TAB_USE_TIME_FOR_BUILD_NUMBER'].to_s.downcase == 'true' || false # rubocop:disable Performance/Casecmp
  if use_timestamp
    Time.now.strftime("%y%m%d%H%M") # rubocop:disable Style/StringLiterals
  else
    ENV['BUILD_NUMBER']
  end
end

def _get_project_build_number
  get_version_number(target: ENV['TAB_PRIMARY_TARGET'])
end

def _set_build_number
  increment_build_number(build_number: _build_number)
end

def _build_ipa
  update_app_identifier(xcodeproj: ENV['FL_UPDATE_PLIST_PROJECT_PATH'],
                        plist_path: ENV['FL_UPDATE_PLIST_PATH'],
                        app_identifier: ENV['FL_UPDATE_PLIST_APP_IDENTIFIER'])
  update_info_plist
  _build_with_gym
end

def _build_with_gym
  install_provisioning_profiles
  _update_team_id_if_necessary
  _update_code_signing_type_if_necessary
  export_method = _get_export_method
  xcconfig_filename = Dir.pwd + '/TAB.release.xcconfig'
  create_xcconfig(filename: xcconfig_filename)

  gym(
    configuration: _get_build_config,
    export_method: export_method,
    xcconfig: xcconfig_filename,
    xcargs: ENV['GYM_XCARGS'] || ''
  )
end

def _get_build_config
  return ENV['FL_BUILD_CONFIGURATION'].nil? ? "Release" : ENV['FL_BUILD_CONFIGURATION']
end

def _get_export_method
  if ENV['GYM_EXPORT_OPTIONS'].nil?
    _fallback_to_enterprise_export_method
  else
    get_info_plist_value(path: ENV['GYM_EXPORT_OPTIONS'], key: 'method')
  end
end

def _fallback_to_enterprise_export_method
  UI.message('Falling back to enterprise `export_method` since `GYM_EXPORT_OPTIONS` is not defined')
  'enterprise'
end

def _update_team_id_if_necessary
  project_path = ENV['FL_PROJECT_SIGNING_PROJECT_PATH']
  team_id = _get_team_id
  if !project_path.to_s.strip.empty? && !team_id.to_s.strip.empty?
    UI.message("Updating project team with project path '#{project_path}' and team id '#{team_id}'.")
    update_project_team(path: project_path, teamid: team_id)
  else
    UI.message('Unable to find project path or project team so skipping updating project team.')
  end
end

def _update_code_signing_type_if_necessary
  automatic_code_signing = ENV['FL_USE_AUTOMATIC_CODE_SIGNING']
  if automatic_code_signing
    UI.message("Updating code signing to '#{automatic_code_signing == 'true' ? 'automatic' : 'manual'}'")
    update_code_signing_settings(
      use_automatic_signing: automatic_code_signing == 'true',
    )
  end
end

def _get_team_id
  team_id = ENV['FL_PROJECT_TEAM_ID']
  unless team_id
    UI.message('Attempting to extract team ID from `GYM_EXPORT_OPTIONS` since `FL_PROJECT_TEAM_ID` is not defined.')
    team_id = get_info_plist_value(path: ENV['GYM_EXPORT_OPTIONS'],
                                   key: 'teamID')
  end
  team_id
end

def _upload_to_app_center
  custom_notes = ENV['TAB_HOCKEY_RELEASE_NOTES'] || ''
  notes = custom_notes == '' ? _create_change_log : custom_notes
  appcenter_upload(
    release_notes: notes
  )
end

def _create_change_log
  cmd = "git log --after={1.day.ago} --pretty=format:'%an%x09%h%x09%cd%x09%s' --date=relative"
  output = `#{cmd}`
  output.to_s.empty? ? 'No Changes' : output
end

def _upload_to_test_flight
  pilot(username: ENV['ITUNES_CONNECT_USERNAME'],
        team_id: ENV['ITUNES_CONNECT_TEAM_ID'],
        itc_provider: ENV['ITUNES_CONNECT_PROVIDER'],
        skip_waiting_for_build_processing: true,
        skip_submission: true)
end

def _notify_slack
  return if ENV['FL_SLACK_CHANNEL'].to_s.strip.empty?
  app_center_download_url = lane_context[SharedValues::APPCENTER_BUILD_INFORMATION]
  build_number = _build_number
  if !app_center_download_url.nil?
    message_prefix = build_number.to_s.empty? ? 'A new build' : "Build #{build_number}"
    new_build_message = "#{message_prefix} is available on <#{app_center_download_url}|app center>"
    slack(message: new_build_message)
  else
    slack
  end
end
