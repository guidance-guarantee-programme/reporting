class Satisfactions
  include ActiveModel::Model

  attr_accessor :start_date, :end_date

  def initialize(start_date:, end_date:)
    @start_date = normalise_date(start_date, 1.month.ago.to_date)
    @end_date   = normalise_date(end_date, Time.zone.today)
  end

  def results
    Satisfaction
      .where(given_at: date_range)
      .order(given_at: :desc)
  end

  private

  def date_range
    start_date.beginning_of_day..end_date.end_of_day
  end

  def normalise_date(date, default)
    date.present? ? Time.zone.parse(date) : default
  end
end
