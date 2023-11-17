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

        @numbers.each_value do |phone_number|
          csv << phone_number.get(headers).map { |v| v.is_a?(Time) ? v.to_date : v }
        end
      end
    end
  end
end
