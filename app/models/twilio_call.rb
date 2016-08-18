class TwilioCall < ActiveRecord::Base
  validates :uid, :inbound_number, :called_at,
            presence: true
  validates :outcome,
            inclusion: %w(forwarded abandoned failed)
  validates :delivery_partner, inclusion: { in: Partners.face_to_face, allow_blank: true }
end
