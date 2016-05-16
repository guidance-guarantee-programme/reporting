require 'importers'

class ImportSmartSurveyDataJob < ActiveJob::Base
  queue_as :default

  def perform
    Importers::SmartSurvey::Importer.new.import
  end
end
