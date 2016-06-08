module Importers
  module SmartSurvey
    class Importer
      def initialize(
        retriever: Retriever,
        call_record: CallRecord,
        saver: Saver,
        config: Rails.configuration.x.smart_survey
      )
        @retriever = retriever.new(config: config)
        @call_record = call_record
        @saver = saver
      end

      def import
        @retriever.process_emails do |email, delivery_partner|
          records = @call_record.build(email.file, delivery_partner)
          @saver.new(records: records).save
        end
      end
    end
  end
end
