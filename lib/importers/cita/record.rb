module Importers
  module Cita
    class Record
      RUBY_TO_XLS_DATE_OFFSET = 25_569
      BOOKING_STATUS_MAP = {
        'Booked' => 'Booked',
        'Completed' => 'Completed',
        'No Show' => 'No Show',
        'Incomplete – client ineligible' => 'Ineligible',
        'Incomplete – change channel' => 'Ineligible',
        'Incomplete – other' => 'Ineligible',
        'Incomplete – time constraint' => 'Ineligible',
        'Bureau Cancelled' => 'Incomplete',
        'Bureau Rescheduled' => 'Incomplete',
        'Client Cancelled' => 'Incomplete',
        'Client Rescheduled' => 'Incomplete'
      }.freeze

      def initialize(row)
        @row = row
      end

      def params
        {
          uid: uid,
          booked_at: created_on,
          cancelled: cancelled,
          booking_at: scheduled_end,
          booking_status: booking_status,
          delivery_partner: Partners::CITA,
          created_at: modified_on,
          transaction_at: scheduled_end
        }
      end

      def valid?
        actual_appointment_2 == '1'
      end

      def uid
        @row['Unique'] # this is a terrible unique field and should be replaced if possible
      end

      def created_on
        timeify @row['Created On']
      end

      def cancelled
        booking_status == 'Cancelled'
      end

      def scheduled_end
        timeify @row['Scheduled End']
      end

      def modified_on
        timeify @row['Modified On']
      end

      def booking_status
        BOOKING_STATUS_MAP.fetch(status_reason)
      end

      private

      def timeify(val)
        return nil if val.blank?

        if val =~ /\A\d+(\.\d+)?\z/
          Time.zone.at((val.to_f - RUBY_TO_XLS_DATE_OFFSET).days).change(usec: 0)
        else
          Time.zone.parse(val)
        end
      end

      def actual_appointment_2
        @row['Actual appointment 2']
      end

      def status_reason
        @row['Status Reason']
      end
    end
  end
end
