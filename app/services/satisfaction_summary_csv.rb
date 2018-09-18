class SatisfactionSummaryCsv < CsvGenerator
  def attributes
    %w(
      name
      cas
      cas_telephone
      cita
      tpas
      tp
      total
      weighted_average
    ).freeze
  end
end
