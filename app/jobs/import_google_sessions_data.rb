require 'importers'

class ImportGoogleSessionsData < ApplicationJob
  queue_as :default

  def perform
    Importers::Google::Sessions::Importer.new.import
  end
end
