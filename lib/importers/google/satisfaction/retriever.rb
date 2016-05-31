require 'google_sheet_retriever'

module Importers
  module Google
    module Satisfaction
      class Retriever
        def initialize(config:, google_sheet_retriever: GoogleSheetRetriever)
          @config = config
          @google_sheet_retriever = google_sheet_retriever
        end

        def process_sheets
          retriever = @google_sheet_retriever.new(config: @config)

          @config.sheets.each do |delivery_partner, sheet_id|
            sheet = retriever.get(sheet_id, @config.range)
            yield sheet, delivery_partner
          end
        end
      end
    end
  end
end
