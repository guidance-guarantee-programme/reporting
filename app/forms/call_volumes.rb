class CallVolumes
  include ActiveModel::Model

  attr_reader :start_date, :end_date

  def initialize(start_date: nil, end_date: nil)
    @start_date = normalise_date(start_date, Time.zone.today.beginning_of_month)
    @end_date = normalise_date(end_date, Time.zone.today)
  end

  def results
    calls = daily_calls_for_period

    date_period.map do |date|
      calls.detect { |call| call.date == date } || DailyCallVolume.new(date: date)
    end
  end

  def total_calls(source)
    daily_calls_for_period.sum(source)
  end

  private

  def daily_calls_for_period
    DailyCallVolume.where(date: date_period)
  end

  def date_period
    start_date..end_date
  end

  def normalise_date(date, default)
    date.present? ? Time.zone.parse(date).to_date : default
  end
end
