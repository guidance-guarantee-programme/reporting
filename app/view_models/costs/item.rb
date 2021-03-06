module Costs
  class Item
    delegate :name, :id, :cost_group, :web_cost, :delivery_partner, :current, to: :@cost_item

    def initialize(cost_item:, year_months:)
      @cost_item = cost_item
      @year_months = year_months
    end

    def all
      @all ||= begin
        grouped_costs = @cost_item.costs.group_by(&:year_month_id)
        @year_months.map do |year_month|
          Costs::MonthItem.new(
            cost_item: @cost_item,
            year_month: year_month,
            costs: grouped_costs.fetch(year_month.id, [])
          )
        end
      end
    end

    def for(year_month_or_id)
      all.detect do |costs_month_item|
        [
          costs_month_item.year_month,
          costs_month_item.year_month.id
        ].include?(year_month_or_id)
      end
    end
  end
end
