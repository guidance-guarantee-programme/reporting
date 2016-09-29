class Cost < ActiveRecord::Base
  belongs_to :cost_item
  belongs_to :user
  belongs_to :year_month

  validates :cost_item, presence: true
  validates :user, presence: true
  validates :value_delta, numericality: { other_than: 0 }
  validates :year_month_id, presence: true

  scope :for, ->(year_month) { where(year_month_id: year_month) }
  scope :web, -> { includes(:cost_item).where(cost_items: { web_cost: true }) }

  scope :by_delivery_partner, -> {
    includes(:cost_item)
      .where.not(cost_items: { delivery_partner: '' })
      .group('cost_items.delivery_partner')
  }
end
