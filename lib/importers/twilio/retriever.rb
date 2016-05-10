require 'twilio-ruby'

module Importers
  module Twilio
    class Retriever
      def initialize(config:)
        @config = config
      end

      def from_api(start_date:, end_date:)
        client = ::Twilio::REST::Client.new(@config.account_sid, @config.auth_token)

        calls = []
        page = client.calls.list('start_time>': start_date, 'start_time<': end_date + 1)

        while page.any?
          calls += page
          page = page.next_page
        end

        calls
      end
    end
  end
end
