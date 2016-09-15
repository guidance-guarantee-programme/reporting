class AppointmentSummary < ActiveRecord::Base
  REPORTING_MONTH_REGEXP = /\A\d{2}\-\d{4}\z/
  REPORTING_MONTH_WRITE_REGEXP = /\A((?<month>\d{2})-(?<year>\d{4})|(?<year>\d{4})-(?<month>\d{2}))\z/
  REPORTING_MONTH_READ_REGEXP = /\A(?<year>\d{4})-(?<month>\d{2})\z/

  validates :source, inclusion:  { in: %w(automatic manual) }, presence: true
  validates :delivery_partner,
            inclusion: { in: Partners.delivery_partners + [Partners::WEB_VISITS] },
            uniqueness: { scope: :reporting_month }
  validates :reporting_month, format: REPORTING_MONTH_REGEXP
  validates :completions,
            numericality: true,
            inclusion: { in: ->(as) { 0..as.transactions.to_i } }
  validates :transactions, numericality: { greater_than_or_equal_to: 0 }
  validates :bookings, numericality: { greater_than_or_equal_to: 0 }

  default_scope { order(:reporting_month) }

  def manual?
    source == 'manual'
  end

  def descripton
    "#{delivery_partner} #{reporting_month}"
  end

  def reporting_month
    if match = super.match(REPORTING_MONTH_READ_REGEXP)
      "#{match['month']}-#{match['year']}"
    else
      super
    end
  end

  def reporting_month=(val)
    if match = val.match(REPORTING_MONTH_WRITE_REGEXP)
      super("#{match['year']}-#{match['month']}")
    else
      super(val)
    end
  end

  def raw_reporting_month
    self[:reporting_month]
  end
end
