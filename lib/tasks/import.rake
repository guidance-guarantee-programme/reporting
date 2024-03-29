# rubocop:disable Metrics/BlockLength
namespace :import do
  desc 'Import CITA satisfaction data'
  task cita_satisfaction: :environment do
    ImportCitaSatisfactionData.perform_later
  end

  desc 'Import PWNI satisfaction data'
  task pwni_satisfaction: :environment do
    ImportPwniSatisfactionData.perform_later
  end

  desc 'Import Tesco Google Satisfaction data from all google spreadsheets'
  task tesco_google_satisfaction: :environment do
    ImportTescoSatisfactionData.perform_later
  end

  desc 'Import Google Satisfaction data from all google spreadsheets'
  task google_satisfaction: :environment do
    ImportGoogleSatisfactionData.perform_later
  end

  desc 'Import Google Sessions data from google analytics (via google spreadsheets)'
  task google_sessions: :environment do
    ImportGoogleSessionsData.perform_later
  end

  desc 'Import TPAS Satisfaction data from unprocessed email attachments'
  task tpas_satisfaction: :environment do
    ImportTpasSatisfactionData.perform_later
  end

  desc 'Import TP Satisfaction data from unprocessed email attachments'
  task tp_satisfaction: :environment do
    ImportTpSatisfactionData.perform_later
  end

  desc 'Import CAS Satisfaction data from unprocessed email attachments'
  task cas_satisfaction: :environment do
    ImportCasSatisfactionData.perform_later
  end

  desc 'Import Twilio data from API for: specified DATE or yesterday'
  task twilio: :environment do
    date_string = ENV.fetch('DATE', Time.zone.yesterday.to_s)
    validate_date_string!(date_string)
    ImportTwilioData.perform_later(date_string)
  end

  desc 'Import TP data from all unprocessed email attachments'
  task tp: :environment do
    ImportTpData.perform_later
  end

  def validate_date_string!(date_string)
    Date.parse(date_string)
  rescue ArgumentError => e
    Bugsnag.notify(e)
    raise
  end
end
# rubocop:enable Metrics/BlockLength
