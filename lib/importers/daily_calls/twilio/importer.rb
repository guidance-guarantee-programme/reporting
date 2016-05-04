module Importers
  module DailyCalls
    module Twilio
      class Importer
        def initialize(call_record: CallRecord, saver: Saver, retriever: Retriever)
          @call_record = call_record
          @saver = saver
          @retriever = retriever.new(config: Rails.configuration.x.twilio)
        end

        def import(start_date:, end_date:)
          raw_calls = @retriever.from_api(start_date: start_date, end_date: end_date)
          calls = @call_record.build(raw_calls)
          @saver.new(calls: calls).store_valid_by_date
        end
      end
    end
  end
end
