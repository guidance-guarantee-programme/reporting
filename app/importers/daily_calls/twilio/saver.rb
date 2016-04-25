module DailyCalls
  module Twilio
    module Saver
      module_function

      def valid_calls_by_date(calls)
        calls_by_date = calls.select(&:valid?).group_by(&:date)

        calls_by_date.map do |date, calls_for_date|
          daily_call = DailyCall.find_or_initialize_by(source: DailyCall::TWILIO, date: date)
          daily_call.call_volume = calls_for_date.count
          daily_call.save!
        end
      end
    end
  end
end
