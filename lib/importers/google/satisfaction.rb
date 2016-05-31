module Importers
  module Google
    module Satisfaction
      autoload :CallRecord, 'importers/google/satisfaction/call_record'
      autoload :Importer, 'importers/google/satisfaction/importer'
      autoload :Retriever, 'importers/google/satisfaction/retriever'
      autoload :Saver, 'importers/google/satisfaction/saver'
    end
  end
end
