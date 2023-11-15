class AppointmentSummary < ApplicationRecord
  belongs_to :year_month

  validates :source, inclusion: { in: %w[automatic manual] }, presence: true
  validates :delivery_partner,
            inclusion: { in: Partners.delivery_partners + [Partners::WEB_VISITS] },
            uniqueness: { scope: :year_month_id }
  validates :year_month, presence: true
  validates :completions,
            numericality: true,
            inclusion: { in: ->(as) { 0..as.transactions.to_i } }
  validates :transactions, numericality: { greater_than_or_equal_to: 0 }
  validates :bookings, numericality: { greater_than_or_equal_to: 0 }

  scope :order_by_month, -> { includes(:year_month).references(:year_month).order('year_months.value') }
  scope :web, -> { where(delivery_partner: Partners::WEB_VISITS) }
  scope :non_web, -> { where.not(delivery_partner: Partners::WEB_VISITS) }

  def manual?
    source == 'manual'
  end

  def descripton
    "#{delivery_partner} #{year_month.short_format}"
  end
end
