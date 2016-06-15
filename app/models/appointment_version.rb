class AppointmentVersion < ActiveRecord::Base
  validates :uid, :booked_at, :booking_at, :booking_status, :delivery_partner,
            presence: true
  validates :delivery_partner, inclusion: { in: Partners.delivery_partners }
end
