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
  scan(skip_slack: skip_slack)
end

desc 'Runs UI tests that are included in the scheme.'
desc 'Environment variables to use: `TAB_UI_TEST_DEVICES`, `TAB_REPORT_FORMATS`, `TAB_UI_TEST_SCHEME`'
lane :ui_test do
  _setup
  skip_slack = ENV['SCAN_SLACK_CHANNEL'].to_s.strip.empty?
  scan(skip_slack: skip_slack,
       devices: ENV['TAB_UI_TEST_DEVICES'],
       output_types: ENV['TAB_REPORT_FORMATS'],
       scheme: ENV['TAB_UI_TEST_SCHEME'])
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
  if ENV['GYM_EXPORT_METHOD'] == 'app-store'
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
  ENV['SCAN_DEVICE'] ||= 'iPhone 6 (12.0)'
  xcode_select(ENV['TAB_XCODE_PATH']) if is_ci && !ENV['TAB_XCODE_PATH'].nil?

  unless ENV['TAB_UI_TEST_SCHEME'].nil? # rubocop:disable Style/GuardClause
    ENV['TAB_REPORT_FORMATS'] = 'html' if ENV['TAB_OUTPUT_TYPES'].nil?
    ENV['TAB_UI_TEST_DEVICES'] ||= 'iPhone 8'
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
  _update_team_id_if_necessary
  update_project_provisioning
  gym
end

def _update_team_id_if_necessary
  project_path = ENV['FL_PROJECT_SIGNING_PROJECT_PATH']
  team_id = ENV['FL_PROJECT_TEAM_ID']
  if !project_path.to_s.strip.empty? && !team_id.to_s.strip.empty?
    UI.message("Updating project team with project path '#{project_path}' and team id '#{team_id}'.")
    update_project_team(path: project_path, teamid: team_id)
  else
    UI.message('Unable to find project path or project team so skipping updating project team.')
  end
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
