module DailyCalls
  module Twilio
    class CallRecord
      MINIMUM_CALL_TIME = 10

      class << self
        def build(calls)
          grouped_calls = calls.sort_by(&:start_time).group_by { |record| record.parent_call_sid || record.sid }

          grouped_calls.values.map do |call_pairs|
            call_pairs.count == 2 ? new(call_pairs) : log(call_pairs)
          end.compact
        end

        private

        def log(calls)
          call_details = calls.map do |call|
            "At: #{call.start_time} Duration: #{call.duration} Sid: #{call.sid} ParentSid: #{call.parent_call_sid}"
          end
          logger.warn("Calls: #{call_details.join(', ')}")

          nil
        end

        def logger
          Logger.new("#{Rails.root}/log/twilio_unpaired_calls.log")
        end
      end

      def initialize(calls)
        @inbound_call, @outbound_call = *calls
      end

      def date
        Time.zone.parse(@inbound_call.start_time).utc.to_date
      end

      def valid?
        @outbound_call.duration.to_i > MINIMUM_CALL_TIME
      end
    end
  end
end
