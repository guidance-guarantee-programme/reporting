require 'rails_helper'
require 'importers'

RSpec.describe Importers::Twilio::Retriever, :vcr do
  subject { described_class.new(config: config) }

  let(:config) { double(:config, account_sid: 'ACCOUNT_SID', auth_token: 'AUTH_TOKEN') }
  let(:start_date) { Date.new(2016, 4, 11) }
  let(:end_date) { Date.new(2016, 4, 12) }

  describe '.from_api' do
    context 'when auth token is valid' do # VCR response has been modified to make this pass
      it 'returns a list of calls', vcr: { cassette_name: 'twilio_single_page_of_data' } do
        response = subject.from_api(start_date: start_date, end_date: end_date)
        expect(response.count).to eq(2)
      end

      context 'and multiple pages exist' do # VCR response has been modified to make this pass
        it 'returns a list of all calls', vcr: { cassette_name: 'twilio_multiple_pages_of_data' } do
          response = subject.from_api(start_date: start_date, end_date: end_date)
          expect(response.count).to eq(3)
        end
      end
    end

    context 'when auth token is not valid' do
      it 'raises an error', vcr: { cassette_name: 'twilio_invalid_auth' } do
        expect do
          subject.from_api(start_date: start_date, end_date: end_date)
        end.to raise_error(Twilio::REST::RequestError)
      end
    end
  end
end
