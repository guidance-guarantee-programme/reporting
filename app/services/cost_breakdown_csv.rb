class CostBreakdownCsv < CsvGenerator
  def self.build(costs)
    new(costs.breakdown.all, costs.months)
  end

  def initialize(record_or_records, months)
    wrapped_rows = Array(record_or_records).map { |row| Row.new(row) }
    super(wrapped_rows)
    @months = months
  end

  def attributes
    %w(
      name
      cost_group
      web_cost
      delivery_partner
    ) + @months.flat_map { |m| [m, "#{m}_forecast"] }
  end

  class Row
    def initialize(record)
      @record = record
    end

    def attributes
      @attributes ||= {
        'name' => @record.name,
        'cost_group' => @record.cost_group,
        'web_cost' => @record.web_cost ? 'Web' : 'Non web',
        'delivery_partner' => @record.delivery_partner
      }.merge(monthly_data)
    end

    def monthly_data
      @record.all.each_with_object({}) do |month_item, result|
        if month_item.count.zero?
          result[month_item.month] = nil
          result["#{month_item.month}_forecast"] = nil
        else
          result[month_item.month] = month_item.value
          result["#{month_item.month}_forecast"] = month_item.forecast ? 'Yes' : 'No'
        end
      end
    end
  end
end
