class CostItem < ActiveRecord::Base
  has_many :costs

  scope :current, -> { where(current: true) }
end
