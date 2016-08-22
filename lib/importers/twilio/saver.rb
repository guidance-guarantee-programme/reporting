module Importers
  module Twilio
    class Saver
      def initialize(calls:)
        @calls = calls
      end

      def save
        ActiveRecord::Base.transaction do
          save_calls!
          save_valid_by_date!
        end
      end

      def save_calls!
        @calls.each do |call|
          TwilioCall.find_by(uid: call.uid) ||
            TwilioCall.create!(call.params)
        end
      end

      def save_valid_by_date!
        calls_by_date = valid_calls.group_by(&:date)

        calls_by_date.map do |date, calls_for_date|
          daily_call = DailyCallVolume.find_or_initialize_by(date: date)
          daily_call.twilio = calls_for_date.count
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
