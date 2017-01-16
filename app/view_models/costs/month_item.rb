module Costs
  class MonthItem
    attr_reader :year_month

    delegate :id, to: :@cost_item, prefix: 'cost_item'

    def initialize(cost_item:, year_month:, costs:)
      @cost_item = cost_item
      @year_month = year_month

      @data = costs.each_with_object(forecast: false, value: 0, count: 0) do |cost, data|
        data[:value] += cost.value_delta
        data[:forecast] = cost.forecast
        data[:count] += 1
      end
    end

    def count
      @data[:count]
    end

    def value
      @data[:value]
    end

    def forecast
      @data[:forecast]
    end
  end
end
