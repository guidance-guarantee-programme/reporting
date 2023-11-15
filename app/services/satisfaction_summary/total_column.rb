class SatisfactionSummary
  class TotalColumn
    SUMMABLE_FIELDS = %i[
      very_satisfied
      fairly_satisfied
      neither_satisfied_nor_dissatisfied
      fairly_dissatisfied
      very_dissatisfied
      respondents
      sum_of_score
      appointment_completions
    ].freeze

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
