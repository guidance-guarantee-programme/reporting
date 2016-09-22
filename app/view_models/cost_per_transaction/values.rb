class CostPerTransaction
  class Values
    attr_reader :total_cost, :transactions

    def initialize(total_cost, transactions)
      @total_cost = total_cost
      @transactions = transactions
    end

    def value
      transactions&.nonzero? ? total_cost.to_f / transactions : 0
    end
  end
end
