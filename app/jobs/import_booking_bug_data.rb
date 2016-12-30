require 'importers'

class ImportBookingBugData < ApplicationJob
  queue_as :default

  def perform
    Importers::BookingBug::Importer.new.import
  end
end
