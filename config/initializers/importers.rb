Rails.configuration.x.twilio.tap do |twilio|
  twilio.auth_token = ENV['TWILIO_AUTH_TOKEN']
  twilio.account_sid = ENV['TWILIO_ACCOUNT_SID']
end

Rails.configuration.x.locations.tap do |locations|
  locations.bearer_token = ENV['LOCATIONS_API_BEARER_TOKEN']
  locations.api_uri = ENV.fetch('LOCATIONS_API_URI', 'http://localhost:3001')
  locations.read_timeout = ENV.fetch('LOCATIONS_API_READ_TIMEOUT', 5).to_i
end

Rails.configuration.x.tp.tap do |tp|
  tp.user_name = ENV['TP_USER_NAME']
  tp.password = ENV['TP_PASSWORD']
  tp.search_string = ENV.fetch('TP_SEARCH_KEYS', 'SUBJECT "TP Daily Call Data"')
  tp.file_name_regexp = Regexp.new(ENV.fetch('TP_FILE_NAME_REGEXP', 'Daily Data File.*\.xlsx'))
  tp.sheet_name = ENV.fetch('TP_SHEET_NAME', 'Call Details')
end

Rails.configuration.x.smart_survey.tap do |ss|
  ss.user_name = ENV['SS_USER_NAME']
  ss.password = ENV['SS_PASSWORD']
  ss.search_string = ENV.fetch('SS_SEARCH_STRING', 'SUBJECT "SmartSurvey Exported Data"')
  ss.file_name_regexp = Regexp.new(ENV.fetch('SS_FILE_NAME_REGEXP', 'RawData--.*\.csv'))
  ss.delivery_partner_regexp = Regexp.new(
    ENV.fetch('SS_DELIVERY_PARTNER_REGEXP', %r{\<b\>Report Name\:\<\/b\> (.*) CSV Export}m)
  )
end

Rails.configuration.x.google_satisfaction.tap do |satisfaction|
  satisfaction.service_account_email = ENV['GOOGLE_SATISFACTION_EMAIL']
  satisfaction.key_data = Base64.decode64(ENV.fetch('GOOGLE_SATISFACTION_KEY', ''))
  satisfaction.key_secret = ENV['GOOGLE_SATISFACTION_SECRET']
  satisfaction.sheets = {
    cita: ENV['GOOGLE_SATISFACTION_CITA_SSID'],
    nicab: ENV['GOOGLE_SATISFACTION_NICAB_SSID'],
    cas: ENV['GOOGLE_SATISFACTION_CAS_SSID']
  }
  satisfaction.range = ENV.fetch('GOOGLE_SATISFACTION_RANGE', 'A:K')
end

Rails.configuration.x.tesco_satisfaction.tap do |satisfaction|
  satisfaction.service_account_email = ENV['GOOGLE_SATISFACTION_EMAIL']
  satisfaction.key_data = Base64.decode64(ENV.fetch('GOOGLE_SATISFACTION_KEY', ''))
  satisfaction.key_secret = ENV['GOOGLE_SATISFACTION_SECRET']
  satisfaction.sheets = {
    cita: ENV.fetch('TESCO_SATISFACTION_CITA_SSID') { '19kxfBGzX677eEDFJl9xL4FX8OtzYZCtrgyylEItwpKA' },
    cas: ENV.fetch('TESCO_SATISFACTION_CAS_SSID')   { '1b3O4ECSDg6xK2beV-PMJ_4USBdN5hhr85Ms42yGmwhU' },
    nicab: ENV.fetch('TESCO_SATISFACTION_NICAB_SSID') { '1yFdUABsZyJGQ10POZtSXbYHCrbkx4wmgP7JHAX278Hs' }
  }
  satisfaction.range = ENV.fetch('TESCO_SATISFACTION_RANGE', 'A:E')
end

Rails.configuration.x.google_sessions.tap do |sessions|
  sessions.service_account_email = ENV['GOOGLE_SESSIONS_EMAIL']
  sessions.key_data = Base64.decode64(ENV.fetch('GOOGLE_SESSIONS_KEY', ''))
  sessions.key_secret = ENV['GOOGLE_SESSIONS_SECRET']
  sessions.sheet = ENV['GOOGLE_SESSIONS_SSID']
  sessions.range = ENV.fetch('GOOGLE_SESSIONS_RANGE', 'Sessions!MonthlyData')
end

Rails.configuration.x.tpas.tap do |tpas|
  tpas.user_name = ENV['TPAS_USER_NAME']
  tpas.password = ENV['TPAS_PASSWORD']
  tpas.search_string = ENV.fetch('TPAS_SEARCH_STRING', 'SUBJECT "TPAS Data"')
  tpas.file_name_regexp = Regexp.new(ENV.fetch('TPAS_FILE_NAME_REGEXP', '.*\.csv'))
end

Rails.configuration.x.tp_satisfaction.tap do |tp|
  tp.user_name = ENV['TP_USER_NAME']
  tp.password = ENV['TP_PASSWORD']
  tp.search_string = ENV.fetch('TP_SATISFACTION_SEARCH_KEYS', 'SUBJECT "Exit Poll"')
  tp.file_name_regexp = Regexp.new(
    ENV.fetch('TP_SATISFACTION_FILE_NAME_REGEXP', 'TP Exit Poll Detail.*\.xlsx')
  )
  tp.sheet_name = ENV.fetch('TP_SATISFACTION_SHEET_NAME', 'Sheet1')
end

Rails.configuration.x.cas_satisfaction.tap do |cas|
  cas.user_name = ENV['CAS_USER_NAME']
  cas.password = ENV['CAS_PASSWORD']
  cas.search_string = ENV.fetch('CAS_SATISFACTION_SEARCH_KEYS', 'SUBJECT "CAS Telephone Exit Poll"')
  cas.file_name_regexp = Regexp.new(
    ENV.fetch('CAS_SATISFACTION_FILE_NAME_REGEXP', 'KM CAS Tele Exit Poll.*\.csv')
  )
end

Rails.configuration.x.pwni.tap do |pwni|
  pwni.user_name = ENV['PWNI_USER_NAME']
  pwni.password = ENV['PWNI_PASSWORD']
  pwni.search_string = ENV.fetch('PWNI_SEARCH_STRING', 'SUBJECT "PW Northern Ireland telephony data"')
  pwni.file_name_regexp = Regexp.new(ENV.fetch('PWNI_FILE_NAME_REGEXP', 'PWNI Telephony.*\.csv'))
end
