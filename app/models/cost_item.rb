class CostItem < ActiveRecord::Base
  has_many :costs

  validates :name, :cost_group, presence: true

  scope :current, -> { where(current: true) }

  def self.allowed_delivery_partners
    Partners.delivery_partners
  end
end
