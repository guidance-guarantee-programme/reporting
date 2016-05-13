Rails.configuration.x.twilio.auth_token = ENV['TWILIO_AUTH_TOKEN']
Rails.configuration.x.twilio.account_sid = ENV['TWILIO_ACCOUNT_SID']

Rails.configuration.x.tp.user_name = ENV['TP_USER_NAME']
Rails.configuration.x.tp.password = ENV['TP_PASSWORD']
Rails.configuration.x.tp.search_string = ENV.fetch('TP_SEARCH_KEYS', 'SUBJECT "TP Daily Call Data"')
Rails.configuration.x.tp.file_name_regexp = Regexp.new(ENV.fetch('TP_FILE_NAME_REGEXP', 'Daily Data File.*\.xlsx'))
Rails.configuration.x.tp.sheet_name = ENV.fetch('TP_SHEET_NAME', 'Call Details')
