class CallVolumes
  include ActiveModel::Model

  attr_reader :start_date, :end_date

  def initialize(start_date: nil, end_date: nil)
    @start_date = normalise_date(start_date, Time.zone.today.beginning_of_month)
    @end_date = normalise_date(end_date, Time.zone.today)
  end

  def results
    CallVolume.by_day(
      daily_call_volumes: daily_call_volumes,
      twilio_call_volumes: twilio_calls_forwarded_by_partner,
      period: period
    )
  end

  def total_calls
    CallVolume.new(
      daily_call_volumes: daily_call_volumes.to_a,
      twilio_call_volumes: twilio_calls_forwarded_by_partner.to_a
    )
  end

  def twilio_calls
    TwilioCall.for_period(period)
  end

  def tp_calls
    TpCall.for_period(period)
  end

  private

  def twilio_calls_forwarded_by_partner
    twilio_calls.forwarded.count_by_partner
  end

  def daily_call_volumes
    DailyCallVolume.where(date: period)
  end

  def period
    start_date..end_date
  end

  def normalise_date(date, default)
    date.present? ? Date.parse(date) : default
  end
end
