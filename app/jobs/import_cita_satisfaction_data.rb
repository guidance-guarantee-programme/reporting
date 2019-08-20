require 'importers'

class ImportCitaSatisfactionData < ApplicationJob
  queue_as :default

  def perform
    Importers::CitaSatisfaction::Importer.new.import
  end
end
