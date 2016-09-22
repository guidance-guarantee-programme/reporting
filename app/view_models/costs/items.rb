module Costs
  class Items
    attr_reader :months

    def initialize(months:)
      @months = months
    end

    def all
      @all ||= begin
        items = CostItem.current | CostItem.during_months(@months)
        items = items.sort_by { |cost_item| [cost_item.cost_group, cost_item.name] }
        items.map do |cost_item|
          Costs::Item.new(cost_item: cost_item, months: @months)
        end
      end
    end

    def by_cost_group
      @by_cost_group ||= all.group_by(&:cost_group)
    end

    def for(id, month)
      all.detect { |item| item.id == id }.for(month)
    end

    def sum_for(month, cost_group = nil)
      scope = cost_group ? by_cost_group.fetch(cost_group) : all

      scope.sum { |item| item.for(month).value }
    end
  end
end
