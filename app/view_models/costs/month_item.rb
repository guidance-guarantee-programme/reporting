module Costs
  class MonthItem
    attr_reader :month

    delegate :id, to: :@cost_item, prefix: 'cost_item'

    def initialize(cost_item:, month:)
      @cost_item = cost_item
      @month = month
    end

    def count
      data[:count]
    end

    def value
      data[:value]
    end

    def forecast
      data[:forecast]
    end

    private

    def data
      @data ||= begin
        costs = Cost.where(month: @month, cost_item_id: @cost_item.id).order(:id)
        costs.each_with_object(forecast: false, value: 0, count: 0) do |cost, data|
          data[:value] += cost.value_delta
          data[:forecast] = cost.forecast
          data[:count] += 1
        end
      end
    end
  end
end
