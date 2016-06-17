class Appointment < ActiveRecord::Base
  before_save :increment_version, :create_version, if: :changed?

  validates :uid, :booked_at, :booking_at, :booking_status, :delivery_partner,
            presence: true
  validates :uid, uniqueness: true
  validates :delivery_partner, inclusion: { in: Partners.delivery_partners }

  scope :bookings, ->(period) { where(booked_at: period, cancelled: false) }
  scope :completions, ->(period) { transactions(period).where(booking_status: 'Complete') }
  scope :transactions, ->(period) { where(transaction_at: period) }
  scope :new_today, -> { where(updated_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, version: 1) }

  def increment_version
    self.version += 1
  end

  def create_version
    AppointmentVersion.create!(attributes.except('updated_at', 'id'))
  end
end
