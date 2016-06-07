module Importers
  module TpasSatisfaction
    class Importer
      def initialize(
        retriever: Retriever,
        record: Record,
        saver: Saver,
        config: Rails.configuration.x.tpas
      )
        @retriever = retriever.new(config: config)
        @record = record
        @saver = saver
      end

      def import
        @retriever.process_emails do |email|
          records = @record.build(io: email.file)
          records && @saver.new(records: records).save
        end
      end
    end
  end
end
