class SatisfactionCsv < CsvGenerator
  def attributes
    %w[
      uid
      given_at
      delivery_partner
      satisfaction_raw
      satisfaction
      location
    ].freeze
  end
end
