module Importers
  module Twilio
    class CallRecord
      MINIMUM_CALL_TIME = 10

      def initialize(calls)
        @inbound_call, @outbound_call = *calls
      end

      def date
        Time.zone.parse(@inbound_call.start_time).utc.to_date
      end

      def valid?
        @outbound_call.duration.to_i > MINIMUM_CALL_TIME
      end

      class << self
        def build(calls)
          grouped_calls = calls.sort_by(&:start_time).group_by { |record| record.parent_call_sid || record.sid }

          valid_pairs, invalid_pairs = grouped_calls.values.partition { |call_group| call_group.count == 2 }

          invalid_pairs.each { |invalid_pair| log(invalid_pair) }
          valid_pairs.map { |valid_pair| new(valid_pair) }
        end

        private

        def log(calls)
          call_details = calls.map do |call|
            "At: #{call.start_time} Duration: #{call.duration} Sid: #{call.sid} ParentSid: #{call.parent_call_sid}"
          end
          Rails.logger.warn("Twilio unpaired calls: #{call_details.join(', ')}")
        end
      end
    end
  end
end
