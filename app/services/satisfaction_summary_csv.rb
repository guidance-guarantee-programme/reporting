class SatisfactionSummaryCsv < CsvGenerator
  def attributes
    %w(
      name
      cas
      cita
      tpas
      tp
      total
      weighted_average
    ).freeze
  end
end
