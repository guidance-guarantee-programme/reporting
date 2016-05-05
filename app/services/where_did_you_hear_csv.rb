require 'csv'

class WhereDidYouHearCsv
  ATTRIBUTES = %w(
    id
    given_at
    delivery_partner
    where
    pension_provider
    location
  ).freeze

  def initialize(records)
    @records = Array(records)
  end

  def call
    CSV.generate do |output|
      output << ATTRIBUTES

      records.each { |record| output << row(record) }
    end
  end
  alias csv call

  private

  attr_reader :records

  def row(record)
    record
      .attributes
      .slice(*ATTRIBUTES)
      .values
      .map(&:to_s)
  end
end
