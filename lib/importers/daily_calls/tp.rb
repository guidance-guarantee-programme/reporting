module Importers
  module DailyCalls
    module TP
      autoload :CallRecord, 'importers/daily_calls/tp/call_record'
      autoload :Importer, 'importers/daily_calls/tp/importer'
      autoload :Retriever, 'importers/daily_calls/tp/retriever'
      autoload :Saver, 'importers/daily_calls/tp/saver'
    end
  end
end
