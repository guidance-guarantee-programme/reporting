module Importers
  module Twilio
    class CallRecord
      MINIMUM_CALL_TIME = 10

      def params # rubocop:disable Metrics/MethodLength
        {
          uid: uid,
          called_at: called_at,
          inbound_number: inbound_number,
          outbound_number: outbound_number,
          call_duration: outbound_call_duration,
          cost: cost,
          outcome: outcome,
          delivery_partner: @location_details['delivery_partner'],
          location_uid: @location_details['uid'],
          location: @location_details['location'],
          location_postcode: @location_details['location_postcode'],
          booking_location: @location_details['booking_location'],
          booking_location_postcode: @location_details['booking_location_postcode']
        }
      end

      def initialize(calls, location_details)
        @inbound_call, @outbound_call = *calls
        @location_details = location_details
      end

      def uid
        @inbound_call.parent_call_sid || @inbound_call.sid
      end

      def called_at
        Time.zone.parse(@inbound_call.start_time)
      end

      def date
        called_at.utc.to_date
      end

      def inbound_number
        @inbound_call.to
      end

      def outbound_number
        @outbound_call&.to
      end

      def outbound_call_duration
        @outbound_call&.duration.to_i
      end

      def cost
        BigDecimal(@inbound_call.price) + (@outbound_call ? BigDecimal(@outbound_call.price) : 0)
      end

      def outcome
        return 'failed' unless @outbound_call
        valid? ? 'forwarded' : 'abandoned'
      end

      def valid?
        outbound_call_duration > MINIMUM_CALL_TIME
      end

      class << self
        def build(calls:, twilio_lookup:)
          grouped_calls = calls.sort_by(&:start_time).group_by { |record| record.parent_call_sid || record.sid }

          valid_pairs, invalid_pairs = partition(grouped_calls.values)

          invalid_pairs.each { |invalid_pair| log(invalid_pair) }
          valid_pairs.map do |call_pair|
            new(
              call_pair,
              twilio_lookup.call(call_pair.first.to)
            )
          end
        end

        private

        def partition(call_pairs)
          call_pairs.partition do |call_group|
            call_group.count == 2 ||
              (call_group.count == 1 && call_group.first.direction == 'inbound')
          end
        end

        def log(calls)
          call_details = calls.map do |call|
            "At: #{call.start_time} Duration: #{call.duration} Sid: #{call.sid} ParentSid: #{call.parent_call_sid}"
          end
          Rails.logger.warn("Twilio unpaired calls (#{call_details.count}): #{call_details.join(', ')}")
        end
      end
    end
  end
end
