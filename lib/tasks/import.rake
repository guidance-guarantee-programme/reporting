namespace :import do
  desc 'Import google forms `where did you hear data`'
  task google: :environment do
    require 'open-uri'
    require 'importers'

    csv_path = ENV.fetch('CSV')
    partner  = ENV.fetch('PARTNER')

    Importers::WhereDidYouHearAboutUs::Google::Importer.new(
      csv: open(csv_path),
      delivery_partner: partner
    ).call

    puts 'done!'
  end

  desc 'Import twilio data for the either the specified DATE or yesterday'
  task twilio: :environment do
    date_string = ENV.fetch('DATE', Time.zone.yesterday.to_s)
    validate_date_string!(date_string)
    ImportTwilioDataJob.perform_later(date_string)
  end

  def validate_date_string!(date_string)
    Date.parse(date_string)
  rescue ArgumentError => e
    Bugsnag.notify(e)
    raise
  end
end
