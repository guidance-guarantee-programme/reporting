class CostBreakdownRawCsv < CsvGenerator
  def initialize(record_or_records)
    wrapped_rows = Array(record_or_records).map { |row| Row.new(row) }
    super(wrapped_rows)
  end

  def attributes
    %w[
      name
      cost_group
      web_cost
      delivery_partner
      month
      value_delta
      forecast
      created_at
    ].freeze
  end

  def web_cost_formatter(value)
    value ? 'yes' : 'no'
  end

  def created_at_formatter(value)
    value.to_date
  end

  class Row
    def initialize(record)
      @record = record
    end

    def attributes
      @record.cost_item.attributes
             .merge(@record.attributes)
             .merge('month' => @record.year_month.value)
    end
  end
end
