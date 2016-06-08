module Importers
  module Google
    module Satisfaction
      class Importer
        def initialize(
          retriever: Retriever,
          call_record: CallRecord,
          saver: Saver,
          config: Rails.configuration.x.google_satisfaction
        )
          @retriever = retriever.new(config: config)
          @call_record = call_record
          @saver = saver
        end

        def import
          @retriever.process_sheets do |sheet, delivery_partner|
            records = @call_record.build(sheet.values, delivery_partner)
            @saver.new(records: records).save
          end
        end
      end
    end
  end
end
