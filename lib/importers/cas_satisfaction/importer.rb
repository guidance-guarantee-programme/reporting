module Importers
  module CasSatisfaction
    class Importer
      def initialize(
        retriever: Retriever,
        record: Record,
        saver: Saver,
        config: Rails.configuration.x.cas_satisfaction
      )
        @retriever = retriever.new(config: config)
        @record = record
        @saver = saver
        @config = config
      end

      def import
        @retriever.process_emails do |email|
          records = @record.build(email.file)
          @saver.new(records: records).save
        end
      end
    end
  end
end
