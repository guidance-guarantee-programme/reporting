module Importers
  module TP
    class Importer
      def initialize(retriever: Retriever, call_record: CallRecord, saver: Saver, config: Rails.configuration.x.tp)
        @retriever = retriever.new(config: config)
        @call_record = call_record
        @saver = saver
        @config = config
      end

      def import
        @retriever.process_emails do |email|
          calls = @call_record.build(io: email.file)
          calls && @saver.new(calls: calls).save
        end
      end
    end
  end
end
