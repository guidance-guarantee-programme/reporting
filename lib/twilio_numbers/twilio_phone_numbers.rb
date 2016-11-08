module TwilioNumbers
  class TwilioPhoneNumbers
    def initialize(config = Rails.configuration.x.twilio)
      @config = config
    end

    def process(phone_numbers) # rubocop:disable Metrics/AbcSize
      twilio_phone_numbers.each do |twilio_phone_number|
        phone_number = phone_numbers.for(twilio_phone_number.phone_number)

        phone_number.set(:twilio_id, twilio_phone_number.sid)
        phone_number.set(:twilio_name, twilio_phone_number.friendly_name)
        phone_number.set(:twilio_number, twilio_phone_number.phone_number)
        phone_number.set(:twilio_voice_app_id, twilio_phone_number.voice_application_sid)
        phone_number.set(:twilio_voice_enabled, twilio_phone_number.capabilities['voice'])
      end
    end

    def twilio_phone_numbers
      client = ::Twilio::REST::Client.new(@config.account_sid, @config.auth_token)

      numbers = page = client.account.incoming_phone_numbers.list
      while (page = page.next_page).any?
        numbers += page
      end
      numbers
    end
  end
end
