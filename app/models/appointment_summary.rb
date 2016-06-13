class AppointmentSummary < ActiveRecord::Base
  validates :source, inclusion:  { in: %w(automatic manual) }, presence: true
  validates :delivery_partner,
            inclusion: { in: Partners.delivery_partners },
            uniqueness: { scope: :reporting_month }
  validates :reporting_month, format: { with: /\A\d{4}\-\d{2}\z/ }
  validates :completions, numericality: { less_than_or_equal_to: ->(as) { as.transactions } }

  default_scope { order(:reporting_month) }

  def manual?
    source == 'manual'
  end

  def descripton
    "#{delivery_partner} #{reporting_month}"
  end
end
