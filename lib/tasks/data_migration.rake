namespace :data_migration do
  desc 'Populate hours on twilio_calls'
  task populate_hours_on_twilio_calls: :environment do
    require 'importers'

    twilio_lookups = Importers::Twilio::TwilioLookup.new.all

    twilio_lookups.each do |inbound_number, details|
      TwilioCall.where(inbound_number: inbound_number, hours: nil).update_all(hours: details['hours'])
    end
  end
end
