module Importers
  module BookingBug
    class Importer
      def initialize(
        retriever: Retriever,
        record: Record,
        saver: Saver,
        summary_saver: Importers::AppointmentSummarySaver,
        config: Rails.configuration.x.booking_bug
      )
        @retriever = retriever.new(config: config)
        @record = record
        @saver = saver
        @summary_saver = summary_saver
      end

      def import
        ActiveRecord::Base.transaction do
          @retriever.process_records do |row_data|
            record = @record.new(row_data)
            next unless record.valid?
            @saver.save(record: record)
          end
          @summary_saver.save(Partners::TPAS)
        end
      end
    end
  end
end
