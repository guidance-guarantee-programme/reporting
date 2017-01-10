class CostPerTransaction
  class CostByDeliveryPartner
    def initialize(cost_by_partner, year_month)
      @cost_by_partner = cost_by_partner
      @year_month = year_month
    end

    def call
      results = @cost_by_partner.dup
      complex_costs = results.slice!(*Partners.delivery_partners)
      complex_costs.each { |split_by, cost| add_costs_by_partner(results, split_by, cost) }

      results
    end

    private

    def add_costs_by_partner(results, split_by, total_cost)
      splitter = "CostPerTransaction::#{split_by.camelcase}".constantize.new(@year_month)
      splitter.call(total_cost).each do |partner, cost|
        results[partner] ||= 0
        results[partner] += cost
      end
    end
  end
end
