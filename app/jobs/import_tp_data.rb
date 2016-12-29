require 'importers'

class ImportTpData < ApplicationJob
  queue_as :default

  def perform
    Importers::TP::Importer.new.import
  end
end
