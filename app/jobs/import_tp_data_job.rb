require 'importers'

class ImportTPDataJob < ActiveJob::Base
  queue_as :default

  def perform
    Importers::TP::Importer.new.import
  end
end
