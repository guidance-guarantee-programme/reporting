Rails.configuration.x.twilio.tap do |twilio|
  twilio.auth_token = ENV['TWILIO_AUTH_TOKEN']
  twilio.account_sid = ENV['TWILIO_ACCOUNT_SID']
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
    ENV.fetch('SS_DELIVERY_PARTNER_REGEXP', '\*Report Name:\* (.*) CSV Export'),
    Regexp::MULTILINE
  )
end

Rails.configuration.x.google_satisfaction.tap do |satisfaction|
  satisfaction.service_account_email = ENV['GOOGLE_SATISFACTION_EMAIL']
  satisfaction.key_data = Base64.decode64(ENV.fetch('GOOGLE_SATISFACTION_KEY', ''))
  satisfaction.key_secret = ENV['GOOGLE_SATISFACTION_SECRET']
  satisfaction.sheets = {
    cita: ENV['GOOGLE_SATISFACTION_CITA'],
    nicab: ENV['GOOGLE_SATISFACTION_NICAB'],
    cas: ENV['GOOGLE_SATISFACTION_CAS']
  }
  satisfaction.range = ENV.fetch('GOOGLE_SATISFACTION_RANGE', 'A:K')
end
