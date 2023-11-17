class Satisfactions
  include ActiveModel::Model

  attr_accessor :year_month_id, :year_month

  def initialize(year_month_id:)
    @year_month = year_month_for(year_month_id, Time.zone.today << 1)
    @year_month_id = @year_month.id
  end

  def results
    Satisfaction
      .where(given_at: @year_month.period)
      .order(given_at: :desc)
  end

  def months
    YearMonth.in_the_past.order(value: :desc)
  end

  private

  def year_month_for(id, default_date)
    return YearMonth.find(id) if id.present?

    YearMonth.find_or_build(year: default_date.year, month: default_date.month)
  end
end
