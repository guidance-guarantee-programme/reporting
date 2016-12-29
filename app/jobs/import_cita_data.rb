require 'importers'

class ImportCitaData < ApplicationJob
  queue_as :default

  def perform(uploaded_file)
    Importers::Cita::Importer.new.import(uploaded_file)
  end
end
