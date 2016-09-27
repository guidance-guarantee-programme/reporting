module Costs
  class Item
    delegate :name, :id, :cost_group, :web_cost, :delivery_partner, :current, to: :@cost_item

    def initialize(cost_item:, months:)
      @cost_item = cost_item
      @months = months
    end

    def all
      @all ||= begin
        @months.map do |month|
          Costs::MonthItem.new(cost_item: @cost_item, month: month)
        end
      end
    end

    def for(month)
      all.detect { |costs_month_item| costs_month_item.month == month }
    end
  end
end
