module Importers
  module Twilio
    autoload :CallRecord, 'importers/twilio/call_record'
    autoload :Importer, 'importers/twilio/importer'
    autoload :Retriever, 'importers/twilio/retriever'
    autoload :Saver, 'importers/twilio/saver'
  end
end
