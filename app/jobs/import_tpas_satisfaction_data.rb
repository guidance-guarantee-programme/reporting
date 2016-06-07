require 'importers'

class ImportTpasSatisfactionData < ActiveJob::Base
  queue_as :default

  def perform
    Importers::TpasSatisfaction::Importer.new.import
  end
end
