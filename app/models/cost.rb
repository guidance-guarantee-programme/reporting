class Cost < ActiveRecord::Base
  belongs_to :cost_item
  belongs_to :user

  validates :cost_item, presence: true
  validates :month, presence: true, format: /\A\d{4}-\d{2}\z/
  validates :user, presence: true
  validates :value_delta, numericality: { other_than: 0 }

  scope :for, ->(month) { where(month: month) }
end
