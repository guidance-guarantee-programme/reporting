class AppointmentSummary < ActiveRecord::Base
  validates :reporting_month, :source, :delivery_partner, presence: true
  validates :source, inclusion:  { in: %w(automatic manual) }
  validates :delivery_partner, inclusion: { in: Partners.delivery_partners }

  default_scope { order(:reporting_month) }

  def manual?
    source == 'manual'
  end
end
