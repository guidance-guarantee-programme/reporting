class Appointment < ApplicationRecord
  COMPLETE = 'Complete'.freeze
  CITA_EXCLUDED_BOOKING_STATUSES = [
    'Booked',
    'Awaiting Status'
  ].freeze

  before_save :increment_version, :create_version, if: :changed?

  validates :uid, :booked_at, :booking_at, :booking_status, :delivery_partner,
            presence: true
  validates :uid, uniqueness: { scope: :delivery_partner }
  validates :delivery_partner, inclusion: { in: Partners.delivery_partners }

  scope :partner, ->(partner) { where(delivery_partner: partner) }
  scope :bookings, ->(partner, period) { partner(partner).where(booked_at: period, cancelled: false) }
  scope :completions, ->(partner, period) { transactions(partner, period).where(booking_status: COMPLETE) }
  scope :transactions, ->(partner, period) {
    scope = partner(partner).where(transaction_at: period)
    scope = scope.where.not(booking_status: CITA_EXCLUDED_BOOKING_STATUSES) if partner == Partners::CITA
    scope
  }
  scope :new_today, ->(partner) { partner(partner).updated_today.where(version: 1) }
  scope :updated_today, -> { where(updated_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) }

  def increment_version
    self.version += 1
  end

  def create_version
    AppointmentVersion.create!(attributes.except('updated_at', 'id'))
  end
end
