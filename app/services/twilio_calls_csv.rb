class TwilioCallsCsv < CsvGenerator
  # rubocop: disable Metrics/MethodLength
  def attributes
    %w[
      called_at
      outcome
      outbound_call_outcome
      call_duration
      cost
      inbound_number
      outbound_number
      caller_phone_number
      location_uid
      location
      location_postcode
      booking_location
      booking_location_postcode
      delivery_partner
      hours
    ].freeze
  end
  # rubocop: enable Metrics/MethodLength

  def called_at_formatter(value)
    value&.strftime('%Y-%m-%d %H:%M:%S')
  end

  def hours_formatter(value)
    return if value.blank?

    value.gsub(/,/, ' -').gsub(/[\r\n]+/, '; ')
  end
end
