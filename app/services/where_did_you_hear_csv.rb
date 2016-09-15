class WhereDidYouHearCsv < CsvGenerator
  def attributes
    %w(
      id
      given_at
      delivery_partner
      heard_from_raw
      heard_from_code
      heard_from
      pension_provider
      location
    ).freeze
  end
end
