module Importers
  module CitaSatisfaction
    class Importer
      def initialize(
        retriever: Retriever,
        record: Record,
        saver: Saver,
        config: Rails.configuration.x.cita_satisfaction
      )
        @retriever = retriever.new(config: config)
        @record = record
        @saver = saver
      end

      def import
        @retriever.process_emails do |email|
          records = @record.build(email)
          @saver.new(records: records).save
        end
      end
    end
  end
end
