module Importers
  module Google
    module Sessions
      class Saver
        def initialize(records:)
          @records = records
        end

        def save
          ActiveRecord::Base.transaction do
            appointment_summaries!
          end
        end

        private

        def appointment_summaries!
          @records.each do |record|
            summary = AppointmentSummary.find_or_initialize_by(record.unique_identifier)
            summary.update_attributes!(record.params)
          end
        end
      end
    end
  end
end
