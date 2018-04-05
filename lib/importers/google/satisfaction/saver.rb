module Importers
  module Google
    module Satisfaction
      class Saver
        def initialize(records:)
          @records = records.select(&:valid?)
        end

        def save
          ActiveRecord::Base.transaction do
            satisfaction!
          end
        rescue CodeLookup::MissingMappingError => e
          Bugsnag.notify(e)
          false
        rescue ActiveRecord::RecordInvalid => e
          Rails.logger.error("Failed: #{e.record.inspect}")
          Bugsnag.notify(e)
          false
        end

        private

        def satisfaction!
          @records.each do |call|
            ::Satisfaction
              .find_or_initialize_by(uid: call.uid)
              .update_attributes!(call.params)
          end
        end
      end
    end
  end
end
