require 'importers'

class ImportCasSatisfactionData < ApplicationJob
  queue_as :default

  def perform
    Importers::CasSatisfaction::Importer.new.import
  end
end
