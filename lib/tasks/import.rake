namespace :import do
  desc 'Import Smart Survey data from all unprocessed email attachments'
  task smart_survey: :environment do
    ImportSmartSurveyDataJob.perform_later
  end

  desc 'Import Twilio data from API for: specified DATE or yesterday'
  task twilio: :environment do
    date_string = ENV.fetch('DATE', Time.zone.yesterday.to_s)
    validate_date_string!(date_string)
    ImportTwilioDataJob.perform_later(date_string)
  end

  desc 'Import TP data from all unprocessed email attachments'
  task tp: :environment do
    ImportTPDataJob.perform_later
  end

  def validate_date_string!(date_string)
    Date.parse(date_string)
  rescue ArgumentError => e
    Bugsnag.notify(e)
    raise
  end
end
