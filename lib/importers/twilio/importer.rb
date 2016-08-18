module Importers
  module Twilio
    class Importer
      def initialize(
        retriever: Retriever,
        call_record: CallRecord,
        saver: Saver,
        twilio_lookup: TwilioLookup.new,
        config: Rails.configuration.x.twilio
      )
        @retriever = retriever.new(config: config)
        @call_record = call_record
        @saver = saver
        @twilio_lookup = twilio_lookup
      end

      def import(start_date:, end_date:)
        raw_calls = @retriever.from_api(start_date: start_date, end_date: end_date)
        calls = @call_record.build(calls: raw_calls, twilio_lookup: @twilio_lookup)
        @saver.new(calls: calls).save
      end
    end
  end
end
