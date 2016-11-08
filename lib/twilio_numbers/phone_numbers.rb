require 'csv'

module TwilioNumbers
  class PhoneNumbers
    def initialize
      @numbers = Hash.new { |hash, twilio_number| hash[twilio_number] = PhoneNumber.new(twilio_number) }
    end

    def for(twilio_number)
      @numbers[twilio_number]
    end

    def exists?(twilio_number)
      @numbers.key?(twilio_number)
    end

    def csv
      headers = @numbers.values.map(&:keys).inject(:|)

      CSV.generate do |csv|
        csv << headers

        @numbers.values.each do |phone_number|
          csv << phone_number.get(headers)
        end
      end
    end
  end
end
