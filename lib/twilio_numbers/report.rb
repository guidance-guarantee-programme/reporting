module TwilioNumbers
  class Report
    def initialize(
      phone_numbers: TwilioNumbers::PhoneNumbers,
      twilio_phone_numbers: TwilioNumbers::TwilioPhoneNumbers.new,
      recent_call_volumes: TwilioNumbers::RecentCallVolumes.new,
      location_details: TwilioNumbers::LocationDetails.new
    )
      @phone_numbers = phone_numbers
      @twilio_phone_numbers = twilio_phone_numbers
      @recent_call_volumes = recent_call_volumes
      @location_details = location_details
    end

    def process
      @phone_numbers.new.tap do |numbers|
        @twilio_phone_numbers.process(numbers)
        @recent_call_volumes.process(numbers, period_starts: [7, 30])
        @location_details.process(numbers)
      end
    end
  end
end
