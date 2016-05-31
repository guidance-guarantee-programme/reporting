require 'importers'

class ImportGoogleSatisfactionDataJob < ActiveJob::Base
  queue_as :default

  def perform
    Importers::Google::Satisfaction::Importer.new.import
  end
end
