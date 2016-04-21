require 'rails_helper'

RSpec.describe DailyCalls::Twilio::Retriever, :vcr do
  subject { described_class }

  let(:start_date) { Date.new(2016, 4, 11) }
  let(:end_date) { Date.new(2016, 4, 12) }

  before do
    allow(Rails.configuration.x.twilio).to receive(:account_sid).and_return('ACCOUNT_SID')
    allow(Rails.configuration.x.twilio).to receive(:auth_token).and_return('AUTH_TOKEN')
  end

  describe '.from_api' do
    context 'when auth token is valid' do # VCR response has been modified to make this pass
      it 'returns a list of calls' do
        response = subject.from_api(start_date: start_date, end_date: end_date)
        expect(response.count).to eq(1)
        expect(response.first).to be_a(Twilio::REST::Call)
      end
    end

    context 'when multiple pages exist' do # VCR response has been modified to make this pass
      it 'returns a list of all calls' do
        response = subject.from_api(start_date: start_date, end_date: end_date)
        expect(response.count).to eq(2)
      end
    end

    context 'when auth token is not valid' do
      it 'raises an error' do
        expect do
          subject.from_api(start_date: start_date, end_date: end_date)
        end.to raise_error(Twilio::REST::RequestError)
      end
    end
  end
end
