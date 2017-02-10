class WhereDidYouHears
  include ActiveModel::Model

  attr_accessor :start_date, :end_date, :page

  def initialize(page:, start_date:, end_date:)
    @page       = page
    @start_date = normalise_date(start_date, 1.month.ago.to_date)
    @end_date   = normalise_date(end_date, Time.zone.now.to_date)
  end

  def results
    WhereDidYouHear
      .where(given_at: date_range)
      .order(given_at: :desc)
  end

  def paginated_results
    results.page(page)
  end

  private

  def date_range
    start_date.beginning_of_day..end_date.end_of_day
  end

  def normalise_date(date, default)
    date.present? ? Date.parse(date) : default
  end
end
