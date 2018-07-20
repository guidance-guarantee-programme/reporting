module Importers
  module TpSatisfaction
    class Importer
      def initialize(
        retriever: Retriever,
        record: Record,
        saver: Saver,
        config: Rails.configuration.x.tp_satisfaction
      )
        @retriever = retriever.new(config: config)
        @record = record
        @saver = saver
        @config = config
      end

      def import
        @retriever.process_emails do |email|
          records = @record.build(io: email.file, sheet_name: @config.sheet_name)
          @saver.new(records: records).save
        end
      end
    end
  end
end
