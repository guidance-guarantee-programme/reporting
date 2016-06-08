require 'importers'

class ImportTpData < ActiveJob::Base
  queue_as :default

  def perform
    Importers::TP::Importer.new.import
  end
end
