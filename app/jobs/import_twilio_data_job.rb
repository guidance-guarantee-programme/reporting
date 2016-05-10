require 'importers'

class ImportTwilioDataJob < ActiveJob::Base
  class InvalidDateParameter < StandardError; end

  queue_as :default

  rescue_from(InvalidDateParameter) do |exception|
    Bugsnag.notify(exception)
  end

  def perform(date_string)
    date = parse_date(date_string)
    Importers::Twilio::Importer.new.import(start_date: date, end_date: date)
  end

  def parse_date(date_string)
    Date.parse(date_string)
  rescue => e
    raise InvalidDateParameter, "#{e.class}: #{date_string}"
  end
end
