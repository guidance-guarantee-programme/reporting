require 'importers'

class ImportSmartSurveyData < ApplicationJob
  queue_as :default

  def perform
    Importers::SmartSurvey::Importer.new.import
  end
end
