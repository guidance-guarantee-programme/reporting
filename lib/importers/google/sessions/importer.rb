require 'google_sheet_retriever'

module Importers
  module Google
    module Sessions
      class Importer
        def initialize(
          retriever: GoogleSheetRetriever,
          call_record: CallRecord,
          saver: Saver,
          config: Rails.configuration.x.google_sessions
        )
          @retriever = retriever.new(config: config)
          @call_record = call_record
          @saver = saver
          @config = config
        end

        def import
          sheet = @retriever.get(@config.sheet, @config.range)
          records = sheet.values.map { |cells| @call_record.new(cells) }
          @saver.new(records: records).save
        end
      end
    end
  end
end
