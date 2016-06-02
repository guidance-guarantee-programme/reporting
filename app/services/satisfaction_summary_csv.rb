# frozen_string_literal: true
class SatisfactionSummaryCsv < CsvGenerator
  def attributes
    %w(
      name
      cas
      cita
      tpas
      total
      weighted_average
    ).freeze
  end
end
