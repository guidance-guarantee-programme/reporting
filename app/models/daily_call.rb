class DailyCall < ActiveRecord::Base
  validates :source,
            presence: true,
            inclusion: { in: %w(twilio) }
  validates :date,
            presence: true,
            uniqueness: { scope: :source }
  validates :call_volume,
            presence: true

  def self.for_month(first_of_month)
    where(date: (first_of_month...first_of_month >> 1))
  end
end
