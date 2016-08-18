require 'location_api'

module Importers
  module Twilio
    class TwilioLookup
      def initialize(config: Rails.configuration.x.locations)
        @config = config
      end

      def call(twilio_number)
        twilio_numbers.fetch(twilio_number, {})
      end

      private

      def twilio_numbers
        @twilio_numbers ||= LocationApi.new(config: @config).all['twilio_numbers']
      end
    end
  end
end
