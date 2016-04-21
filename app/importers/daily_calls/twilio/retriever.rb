require 'twilio-ruby'

module DailyCalls
  module Twilio
    module Retriever
      module_function

      def from_api(start_date:, end_date:)
        client = ::Twilio::REST::Client.new(account_sid, auth_token)

        calls = []
        page = client.calls.list('start_time>': start_date, 'start_time<': end_date + 1)

        while page.any?
          calls += page
          page = page.next_page
        end

        calls
      end

      def account_sid
        Rails.configuration.x.twilio.account_sid
      end

      def auth_token
        Rails.configuration.x.twilio.auth_token
      end
    end
  end
end
