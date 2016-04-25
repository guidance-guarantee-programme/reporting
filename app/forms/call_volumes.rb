class CallVolumes
  include ActiveModel::Model

  attr_reader :start_date, :end_date

  def initialize(start_date: nil, end_date: nil)
    @start_date = normalise_date(start_date, Time.zone.today.beginning_of_month)
    @end_date = normalise_date(end_date, Time.zone.today)
  end

  def results
    calls = DailyCall.where(
      date: start_date..end_date,
      source: DailyCall::TWILIO
    )

    (start_date..end_date).map do |date|
      calls.detect { |call| call.date == date } || DailyCall.new(date: date, call_volume: nil)
    end
  end

  def total_twilio_calls
    DailyCall.where(
      date: start_date..end_date,
      source: DailyCall::TWILIO
    ).sum(:call_volume)
  end

  private

  def normalise_date(date, default)
    date.present? ? Time.zone.parse(date).to_date : default
  end
end
