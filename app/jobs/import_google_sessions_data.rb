require 'importers'

class ImportGoogleSessionsData < ActiveJob::Base
  queue_as :default

  def perform
    Importers::Google::Sessions::Importer.new.import
  end
end
