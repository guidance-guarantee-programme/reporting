require 'importers'

class ImportTpasSatisfactionData < ApplicationJob
  queue_as :default

  def perform
    Importers::TpasSatisfaction::Importer.new.import
  end
end
