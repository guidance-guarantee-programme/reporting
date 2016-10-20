require 'location_api'

module Importers
  module Twilio
    class TwilioLookup
      def initialize(config: Rails.configuration.x.locations)
        @twilio_numbers = LocationApi.new(config: config).all['twilio_numbers']
      end

      def call(twilio_number)
        @twilio_numbers.fetch(twilio_number, {})
      end

      def all
        @twilio_numbers
      end
    end
  end
end
