module Importers
  module Google
    module Sessions
      autoload :CallRecord, 'importers/google/sessions/call_record'
      autoload :Importer, 'importers/google/sessions/importer'
      autoload :Saver, 'importers/google/sessions/saver'
    end
  end
end
