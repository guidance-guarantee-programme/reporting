class SatisfactionSummary
  class PartnerColumn
    VERY_SATISFIED = 4
    FAIRLY_SATISFIED = 3
    NEITHER_SATISFIED_NOR_DISSATISFIED = 2
    FAIRLY_DISSATISFIED = 1
    VERY_DISSATISFIED = 0
    MAX_SATISFACTION_SCORE = VERY_SATISFIED

    attr_reader :satisfaction_data
    attr_accessor :appointment_completions

    def initialize
      @appointment_completions = 0
      @satisfaction_data = Hash.new(0)
    end

    def very_satisfied
      @satisfaction_data[VERY_SATISFIED]
    end

    def fairly_satisfied
      @satisfaction_data[FAIRLY_SATISFIED]
    end

    def neither_satisfied_nor_dissatisfied
      @satisfaction_data[NEITHER_SATISFIED_NOR_DISSATISFIED]
    end

    def fairly_dissatisfied
      @satisfaction_data[FAIRLY_DISSATISFIED]
    end

    def very_dissatisfied
      @satisfaction_data[VERY_DISSATISFIED]
    end

    def sum_of_score
      very_satisfied * VERY_SATISFIED +
        fairly_satisfied * FAIRLY_SATISFIED +
        neither_satisfied_nor_dissatisfied * NEITHER_SATISFIED_NOR_DISSATISFIED +
        fairly_dissatisfied * FAIRLY_DISSATISFIED +
        very_dissatisfied * VERY_DISSATISFIED
    end

    def respondents
      @satisfaction_data.values.sum
    end

    def gdx_average_score
      return 0.0 if respondents.zero?

      sum_of_score.to_f / (MAX_SATISFACTION_SCORE * respondents)
    end

    def top_two_score
      return 0.0 if respondents.zero?

      (very_satisfied + fairly_satisfied).to_f / respondents
    end
  end
end
