require 'importers'

class ImportBookingBugData < ActiveJob::Base
  queue_as :default

  def perform
    Importers::BookingBug::Importer.new.import
  end
end
