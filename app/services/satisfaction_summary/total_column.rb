class SatisfactionSummary
  class TotalColumn
    SUMMABLE_FIELDS = %i(
      delighted
      very_pleased
      satisfied
      frustrated
      very_frustrated
      respondents
      sum_of_score
      appointment_completions
    ).freeze

    def initialize(partners)
      @partners = partners
    end

    SUMMABLE_FIELDS.each do |field|
      define_method(field) do
        @partners.sum(&field)
      end
    end
  end
end
