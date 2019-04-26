require 'importers'

class ImportPwniSatisfactionData < ApplicationJob
  queue_as :default

  def perform
    Importers::PwniSatisfaction::Importer.new.import
  end
end
