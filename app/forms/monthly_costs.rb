class MonthlyCosts
  include ActiveModel::Model

  attr_reader :year_month_id

  def initialize(params = {})
    @year_month_id = params.fetch(:year_month_id)
    @items = {}
  end

  def add(costs_month_item)
    @items[costs_month_item.cost_item_id] = Item.new(costs_month_item)
  end

  class Item
    include ActiveModel::Model

    attr_reader :id
    attr_accessor :value, :forecast

    def initialize(costs_month_item)
      @id = costs_month_item.cost_item_id
      @value = costs_month_item.value
      @forecast = costs_month_item.forecast
    end
  end
end
