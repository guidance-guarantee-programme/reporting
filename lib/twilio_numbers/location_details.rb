require 'location_api'

module TwilioNumbers
  class LocationDetails
    def initialize(config = Rails.configuration.x.locations)
      @config = config
    end

    def process(phone_numbers)
      locations.each do |inbound_number, location|
        phone_number = phone_numbers.for(inbound_number)

        phone_number.set(:delivery_partner, location['delivery_partner'])
        phone_number.set(:location, location['location'])
        phone_number.set(:location_postcode, location['location_postcode'])
        phone_number.set(:booking_location, location['booking_location'])
        phone_number.set(:booking_location_postcode, location['booking_location_postcode'])
      end
    end

    private

    def locations
      LocationApi.new(config: @config).all['twilio_numbers']
    end
  end
end
