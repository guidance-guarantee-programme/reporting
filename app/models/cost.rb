class Cost < ActiveRecord::Base
  belongs_to :cost_item
  belongs_to :user

  validates :cost_item, presence: true
  validates :month, presence: true, format: /\A\d{4}-\d{2}\z/
  validates :user, presence: true
  validates :value_delta, numericality: { other_than: 0 }

  scope :for, ->(month) { where(month: month) }
  scope :web, -> { includes(:cost_item).where(cost_items: { web_cost: true }) }

  scope :by_delivery_partner, -> {
    includes(:cost_item)
      .where.not(cost_items: { delivery_partner: '' })
      .group('cost_items.delivery_partner')
  }
end
