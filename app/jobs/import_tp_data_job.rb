require 'importers'

class ImportTPDataJob < ActiveJob::Base
  queue_as :default

  def perform
    Importers::DailyCalls::TP::Importer.new.import
  end
end
