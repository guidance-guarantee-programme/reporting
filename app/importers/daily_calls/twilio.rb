module DailyCalls
  module Twilio
    autoload :CallRecord, 'daily_calls/twilio/call_record'
    autoload :Importer, 'daily_calls/twilio/importer'
    autoload :Retriever, 'daily_calls/twilio/retriever'
    autoload :Saver, 'daily_calls/twilio/saver'
  end
end
