class SatisfactionSummary
  class AverageColumn
    def initialize(partners)
      @partners = partners
    end

    def gdx_average_score
      weighted_average(:gdx_average_score)
    end

    def top_two_score
      weighted_average(:top_two_score)
    end

    private

    def total_appointments
      @total_appointments ||= @partners.sum(&:appointment_completions)
    end

    def weighted_average(field)
      return 0.0 if total_appointments.zero?

      @partners.sum do |partner|
        partner.public_send(field) * partner.appointment_completions
      end / total_appointments
    end
  end
end
