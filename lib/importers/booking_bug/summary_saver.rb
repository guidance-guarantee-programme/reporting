module Importers
  module BookingBug
    class SummarySaver
      def self.save
        new_records_booked_at = Appointment.new_today.uniq.pluck(:booked_at)
        month_ends_with_new_records = new_records_booked_at.map(&:end_of_month).uniq
        month_ends_with_new_records.each { |month_end| new(month_end).save }
      end

      def initialize(period_end)
        @period = period_end.beginning_of_month..period_end
        @reporting_month = period_end.strftime('%Y-%m')
      end

      def save
        summary = AppointmentSummary.find_or_initialize_by(
          delivery_partner: Partners::TPAS,
          reporting_month: @reporting_month
        )

        return if summary.manual?

        summary.update_attributes!(transactions: transactions, bookings: bookings, completions: completions)
      end

      def completions
        Appointment.completions(@period).count
      end

      def bookings
        Appointment.bookings(@period).count
      end

      def transactions
        Appointment.transactions(@period).count
      end
    end
  end
end
