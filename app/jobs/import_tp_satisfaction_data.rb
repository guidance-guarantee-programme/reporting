require 'importers'

class ImportTpSatisfactionData < ApplicationJob
  queue_as :default

  def perform
    Importers::TpSatisfaction::Importer.new.import
  end
end
