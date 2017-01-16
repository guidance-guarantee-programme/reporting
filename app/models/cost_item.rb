class CostItem < ApplicationRecord
  has_many :costs

  def self.allowed_delivery_partners
    Partners.delivery_partners + CostPerTransaction::DELIVERY_PARTNER_BREAKDOWN_METHODS
  end

  validates :name, :cost_group, presence: true
  validates :delivery_partner, inclusion: { in: allowed_delivery_partners, allow_blank: true }

  scope :current, -> { reporting_includes.where(current: true) }
  scope :during_months, ->(year_months) { reporting_includes.where(costs: { year_month_id: year_months }) }
  scope :reporting_includes, -> { includes(costs: :year_month) }
end
