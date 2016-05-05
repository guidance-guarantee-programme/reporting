module Importers
  module DailyCalls
    module TP
      class Importer
        def initialize(retriever: Retriever, call_record: CallRecord, saver: Saver)
          @retriever = retriever.new(config: Rails.configuration.x.tp)
          @call_record = call_record
          @saver = saver
        end

        def import
          @retriever.process_emails do |email|
            calls = @call_record.build(email.file)
            @saver.new(calls: calls).store_valid_by_date
          end
        end
      end
    end
  end
end
