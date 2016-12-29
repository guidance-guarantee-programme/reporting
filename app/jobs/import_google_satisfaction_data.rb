require 'importers'

class ImportGoogleSatisfactionData < ApplicationJob
  queue_as :default

  def perform
    Importers::Google::Satisfaction::Importer.new.import
  end
end
