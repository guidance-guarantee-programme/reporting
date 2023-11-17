class CostsReport
  include ActiveModel::Model

  attr_reader :start_month_id, :end_month_id, :year_months

  def initialize(start_month_id: nil, end_month_id: nil)
    start_month = year_month_for(start_month_id, Time.zone.today << 2)
    end_month = year_month_for(end_month_id, Time.zone.today)

    @start_month_id = start_month.id
    @end_month_id = end_month.id

    @year_months = YearMonth.between(start_month, end_month)
  end

  def by_month
    year_months.map { |year_month| CostPerTransaction.new(year_month) }
  end

  def breakdown
    @breakdown = Costs::Items.new(year_months: year_months)
  end

  def raw
    Cost.includes(:cost_item, :year_month).where(year_month_id: year_months)
  end

  private

  def year_month_for(id, default_date)
    return YearMonth.find(id) if id.present?

    YearMonth.find_or_build(year: default_date.year, month: default_date.month)
  end
end
