class CostsReport
  include ActiveModel::Model

  attr_reader :start_month, :end_month

  validates :start_month, :end_month, format: /\A[01]\d-2\z/

  def initialize(start_month: nil, end_month: nil)
    @start_month = start_month.presence || (Time.zone.today << 2).strftime('%m-%Y')
    @end_month = end_month.presence || Time.zone.today.strftime('%m-%Y')
  end

  def months
    start_date = to_date(start_month)
    end_date = to_date(end_month)

    return [] unless start_date && end_date

    (start_date..end_date)
      .map { |d| d.strftime('%m-%Y') }
      .uniq
      .map { |m| CostPerTransaction.new(m) }
  end

  private

  def to_date(month)
    Date.parse("01-#{month}")
  rescue ArgumentError
    nil
  end
end
