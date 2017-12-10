module Importers
  module Tesco
    module Satisfaction
      autoload :CallRecord, 'importers/tesco/satisfaction/call_record'
      autoload :Importer, 'importers/tesco/satisfaction/importer'
      autoload :Retriever, 'importers/tesco/satisfaction/retriever'
      autoload :Saver, 'importers/tesco/satisfaction/saver'
    end
  end
end
