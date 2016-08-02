module Costs
  class Items
    attr_reader :months

    def initialize(months:)
      @months = months
    end

    def all
      @all ||= begin
        items = CostItem.current | CostItem.includes(:costs).where(costs: { month: @months })
        items.map do |cost_item|
          Costs::Item.new(cost_item: cost_item, months: @months)
        end
      end
    end

    def for(id, month)
      all.detect { |item| item.id == id }.for(month)
    end

    def sum_for(month)
      all.sum { |item| item.for(month).value }
    end
  end
end
