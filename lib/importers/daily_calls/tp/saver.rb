module Importers
  module DailyCalls
    module TP
      class Saver
        def initialize(calls:)
          @calls = calls
        end

        def store_valid_by_date
          calls_by_date = valid_calls.group_by(&:date)

          ActiveRecord::Base.transaction do
            calls_by_date.map do |date, calls_for_date|
              daily_call = DailyCallVolume.find_or_initialize_by(date: date)
              daily_call.tp = calls_for_date.count
              daily_call.save!
            end
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
