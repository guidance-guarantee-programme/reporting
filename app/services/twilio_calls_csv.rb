class TwilioCallsCsv < CsvGenerator
  def attributes # rubocop: disable Metrics/MethodLength
    %w(
      called_at
      outcome
      call_duration
      cost
      inbound_number
      outbound_number
      location_uid
      location
      location_postcode
      booking_location
      booking_location_postcode
      delivery_partner
    ).freeze
  end

  def called_at_formatter(value)
    value&.strftime('%Y-%m-%d %H:%M:%S')
  end
end
