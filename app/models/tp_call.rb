class TpCall < ApplicationRecord
  validates :uid, :outcome, :called_at, presence: true

  scope :for_period, ->(period) { where('date(called_at) BETWEEN ? AND ?', period.first, period.last) }
end
