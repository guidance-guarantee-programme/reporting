module Importers
  class AppointmentSummarySaver
    def self.save!(partner)
      new_records_booked_at = Appointment.new_today(partner).distinct.pluck(:booked_at)
      month_ends_with_new_records = new_records_booked_at.map(&:end_of_month).uniq
      month_ends_with_new_records.each { |month_end| new(partner, month_end).save! }
    end

    def initialize(partner, period_end)
      @partner = partner
      @year_month = YearMonth.find_or_build(year: period_end.year, month: period_end.month)
    end

    def save!
      summary = AppointmentSummary.find_or_initialize_by(
        delivery_partner: @partner,
        year_month_id: @year_month.id
      )

      return if summary.manual?

      summary.update_attributes!(transactions: transactions, bookings: bookings, completions: completions)
    end

    def completions
      Appointment.completions(@partner, @year_month.period).count
    end

    def bookings
      Appointment.bookings(@partner, @year_month.period).count
    end

    def transactions
      Appointment.transactions(@partner, @year_month.period).count
    end
  end
end
