class DailyCallVolume < ActiveRecord::Base
  validates :date,
            presence: true,
            uniqueness: true
  validates :twilio, :tp,
            numericality: { greater_than_or_equal_to: 0 }
end
