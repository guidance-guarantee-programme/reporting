require 'importers'

class ImportTescoSatisfactionData < ApplicationJob
  queue_as :default

  def perform
    Importers::Tesco::Satisfaction::Importer.new.import
  end
end
