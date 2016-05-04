module Importers
  module DailyCalls
    module Twilio
      class Saver
        def initialize(calls:)
          @calls = calls
        end

        def store_valid_by_date
          calls_by_date = valid_calls.group_by(&:date)

          calls_by_date.map do |date, calls_for_date|
            daily_call = DailyCallVolume.find_or_initialize_by(source: DailyCallVolume::TWILIO, date: date)
            daily_call.call_volume = calls_for_date.count
            daily_call.save!
          end
        end

        private

        def valid_calls
          @calls.select(&:valid?)
        end
      end
    end
  end
end
