class TpCallsCsv < CsvGenerator
  def attributes
    %w(
      uid
      called_at
      outcome
      call_duration
      third_party_referring
      pension_provider
    ).freeze
  end

  def called_at_formatter(value)
    value&.strftime('%Y-%m-%d %H:%M:%S')
  end
end
