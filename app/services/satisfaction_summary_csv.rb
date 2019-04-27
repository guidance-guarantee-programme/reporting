class SatisfactionSummaryCsv < CsvGenerator
  def attributes # rubocop:disable MethodLength
    %w(
      name
      cas
      cas_telephone
      cita
      tpas
      tp
      nicab
      nicab_telephone
      total
      weighted_average
    ).freeze
  end
end
