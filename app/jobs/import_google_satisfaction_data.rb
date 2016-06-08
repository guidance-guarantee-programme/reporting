require 'importers'

class ImportGoogleSatisfactionData < ActiveJob::Base
  queue_as :default

  def perform
    Importers::Google::Satisfaction::Importer.new.import
  end
end
