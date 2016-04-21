class DailyCallVolume < ActiveRecord::Base
  TWILIO = 'twilio'.freeze

  validates :source,
            presence: true,
            inclusion: { in: [TWILIO] }
  validates :date,
            presence: true,
            uniqueness: { scope: :source }
  validates :call_volume,
            presence: true
end
