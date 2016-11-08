module TwilioNumbers
  class PhoneNumber
    def initialize(twilio_number)
      @data = {}.with_indifferent_access
      set(:twilio_number, twilio_number)
    end

    def set(field, value)
      @data[field] = value
    end

    def get(headers)
      headers.map { |field| @data[field] }
    end

    def keys
      @data.keys
    end
  end
end
