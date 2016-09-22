class CostItem < ActiveRecord::Base
  has_many :costs

  def self.allowed_delivery_partners
    Partners.delivery_partners + CostPerTransaction::DELIVERY_PARTNER_BREAKDOWN_METHODS
  end

  validates :name, :cost_group, presence: true
  validates :delivery_partner, inclusion: { in: allowed_delivery_partners, allow_blank: true }

  scope :current, -> { where(current: true) }
  scope :during_months, ->(months) { includes(:costs).where(costs: { month: months }) }
end
