module Importers
  module DailyCalls
    module Twilio
      autoload :CallRecord, 'importers/daily_calls/twilio/call_record'
      autoload :Importer, 'importers/daily_calls/twilio/importer'
      autoload :Retriever, 'importers/daily_calls/twilio/retriever'
      autoload :Saver, 'importers/daily_calls/twilio/saver'
    end
  end
end
