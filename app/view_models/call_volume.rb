class CallVolume
  def self.by_day(daily_call_volumes:, twilio_call_volumes:, period:)
    daily_calls_by_date = daily_call_volumes.group_by(&:date)
    twilio_calls_by_date = twilio_call_volumes.group_by_date.group_by(&:date)

    period.map do |date|
      new(
        date: date,
        daily_call_volumes: daily_calls_by_date.fetch(date, []),
        twilio_call_volumes: twilio_calls_by_date.fetch(date, [])
      )
    end
  end

  attr_reader :date

  def initialize(daily_call_volumes:, twilio_call_volumes:, date: nil)
    @date = date
    @daily_call_volumes = daily_call_volumes
    @twilio_call_volumes = twilio_call_volumes
  end

  def contact_centre
    @daily_call_volumes.sum(&:contact_centre)
  end

  def twilio
    @daily_call_volumes.sum(&:twilio)
  end

  def twilio_cas
    twilio_for(Partners::CAS)
  end

  def twilio_cita
    twilio_for(Partners::CITA)
  end

  def twilio_nicab
    twilio_for(Partners::NICAB)
  end

  def twilio_unknown
    twilio_for(nil)
  end

  def attributes
    {
      'date' => date,
      'contact_centre' => contact_centre,
      'twilio' => twilio,
      'twilio_cas' => twilio_cas,
      'twilio_cita' => twilio_cita,
      'twilio_nicab' => twilio_nicab,
      'twilio_unknown' => twilio_unknown
    }
  end

  private

  def twilio_for(partner)
    @twilio_call_volumes
      .select { |twilio_call_volume| twilio_call_volume.delivery_partner == partner }
      .sum(&:count)
  end
end
