module Importers
  module Cita
    class Importer
      def initialize(
        record: Record,
        saver: Saver,
        summary_saver: Importers::AppointmentSummarySaver
      )
        @record = record
        @saver = saver
        @summary_saver = summary_saver
      end

      def import(uploaded_file)
        csv = CSV.new(uploaded_file.data, headers: true)

        ActiveRecord::Base.transaction do
          csv.each do |row_data|
            record = @record.new(row_data)
            next unless record.valid?

            @saver.save!(record: record)
          end
          @summary_saver.save!(Partners::CITA)
          uploaded_file.update!(processed: true)
        end
      end
    end
  end
end
