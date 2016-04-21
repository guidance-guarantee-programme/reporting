module DailyCalls
  module Twilio
    autoload :CallRecord, 'daily_calls/twilio/call_record'
    autoload :Retriever, 'daily_calls/twilio/retriever'
    autoload :Saver, 'daily_calls/twilio/saver'

    module_function

    def import(start_date:, end_date:)
      raw_calls = Retriever.from_api(start_date: start_date, end_date: end_date)
      calls = CallRecord.build(raw_calls)
      Saver.valid_calls_by_date(calls)
    end
  end
end
