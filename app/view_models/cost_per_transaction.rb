class CostPerTransaction
  DELIVERY_PARTNER_BREAKDOWN_METHODS = %w(split_by_call_volume).freeze
  attr_reader :month

  def initialize(month)
    @month = month
  end

  def overall
    Values.new(
      cost_scope.sum(:value_delta),
      transaction_scope.sum(:transactions)
    )
  end

  def web
    Values.new(
      cost_scope.web.sum(:value_delta),
      nil
    )
  end

  Partners.delivery_partners.each do |partner|
    define_method partner do
      Values.new(
        cost_by_delivery_partner.fetch(partner, 0),
        transaction_scope.where(delivery_partner: partner).sum(:transactions)
      )
    end
  end

  private

  def cost_scope
    Cost.for(formatted_month)
  end

  def transaction_scope
    AppointmentSummary.where(reporting_month: formatted_month)
  end

  def cost_by_delivery_partner
    @cost_by_delivery_partner ||= begin
      calls_by_partner = cost_scope.by_delivery_partner.sum(:value_delta)
      CostByDeliveryPartner.new(calls_by_partner, formatted_month).call
    end
  end

  def formatted_month
    @formatted_month ||= month.split('-').reverse.join('-')
  end
end
