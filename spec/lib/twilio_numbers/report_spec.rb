require 'rails_helper'
require 'twilio_numbers'

RSpec.describe TwilioNumbers::Report, vcr: { cassette_name: 'twilio_numbers_report' } do
  let(:config) { double(account_sid: 'ACCOUNT_SID', auth_token: 'AUTH_TOKEN') }
  subject { described_class.new(twilio_phone_numbers: TwilioNumbers::TwilioPhoneNumbers.new(config)).process }

  skip 'can generate the report CSV' do
    travel_to Date.new(2016, 11, 9) do
      create(:twilio_call, inbound_number: '+442895072271', called_at: 4.days.ago)
      create(:twilio_call, inbound_number: '+442895072271', called_at: 20.days.ago)

      csv_output = File.read(Rails.root.join('spec', 'fixtures', 'twilio_numbers_report.csv'))
      expect(subject.csv).to eq(csv_output)
    end
  end
end
