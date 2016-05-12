# frozen_string_literal: true
class WhereDidYouHearCsv < CsvGenerator
  def attributes
    %w(
      id
      given_at
      delivery_partner
      where_raw
      where_code
      where
      pension_provider
      location
    ).freeze
  end
end
