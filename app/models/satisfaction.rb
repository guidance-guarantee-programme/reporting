class Satisfaction < ApplicationRecord
  validates :uid, presence: true, uniqueness: true
  validates :given_at, presence: true
  validates :delivery_partner,
            inclusion: { in: Partners.delivery_partners }
  validates :satisfaction,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 4
            }
end
