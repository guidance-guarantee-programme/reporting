class Appointment < ActiveRecord::Base
  before_save :increment_version, :create_version, if: :changed?

  validates :uid, :booked_at, :booking_at, :booking_status, :delivery_partner,
            presence: true
  validates :uid, uniqueness: true
  validates :delivery_partner, inclusion: { in: Partners.delivery_partners }

  scope :bookings, ->(end_point) { where('booked_at <= ?', end_point).where(cancelled: false) }
  scope :completions, ->(end_point) { transactions(end_point).where(booking_status: 'Complete') }
  scope :transactions, ->(end_point) { where('booking_at <= ?', end_point) }
  scope :new_today, -> { where(updated_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, version: 1) }

  def increment_version
    self.version += 1
  end

  def create_version
    AppointmentVersion.create!(attributes.except('updated_at', 'id'))
  end
end
