class SatisfactionSummary
  class PartnerColumn
    DELIGHTED = 4
    VERY_PLEASED = 3
    SATISFIED = 2
    FRUSTRATED = 1
    VERY_FRUSTRATED = 0
    MAX_SATISFACTION_SCORE = DELIGHTED

    attr_reader :satisfaction_data
    attr_accessor :appointment_completions

    def initialize
      @appointment_completions = 0
      @satisfaction_data = Hash.new(0)
    end

    def delighted
      @satisfaction_data[DELIGHTED]
    end

    def very_pleased
      @satisfaction_data[VERY_PLEASED]
    end

    def satisfied
      @satisfaction_data[SATISFIED]
    end

    def frustrated
      @satisfaction_data[FRUSTRATED]
    end

    def very_frustrated
      @satisfaction_data[VERY_FRUSTRATED]
    end

    def sum_of_score
      delighted * DELIGHTED +
        very_pleased * VERY_PLEASED +
        satisfied * SATISFIED +
        frustrated * FRUSTRATED +
        very_frustrated * VERY_FRUSTRATED
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

      (delighted + very_pleased).to_f / respondents
    end
  end
end
