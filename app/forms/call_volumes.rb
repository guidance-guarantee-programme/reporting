class CallVolumes
  include ActiveModel::Model

  attr_reader :start_date, :end_date

  def initialize(start_date: nil, end_date: nil)
    @start_date = normalise_date(start_date, Time.zone.today.beginning_of_month)
    @end_date = normalise_date(end_date, Time.zone.today)
  end

  def results
    calls = twilio_daily_calls_for_range

    date_range.map do |date|
      calls.detect { |call| call.date == date } || DailyCallVolume.new(date: date, call_volume: 0)
    end
  end

  def total_twilio_calls
    twilio_daily_calls_for_range.sum(:call_volume)
  end

  private

  def twilio_daily_calls_for_range
    DailyCallVolume.where(
      date: date_range,
      source: DailyCallVolume::TWILIO
    )
  end

  def date_range
    start_date..end_date
  end

  def normalise_date(date, default)
    date.present? ? Time.zone.parse(date).to_date : default
  end
end
