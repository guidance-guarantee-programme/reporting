require 'rails_helper'

RSpec.describe DailyCalls::Twilio::CallRecord, :vcr do
  subject { described_class }

  describe '.build' do
    let(:start_time) { Time.zone.now }
    let(:inbound_call) { double(:inbound_call, start_time: start_time, sid: '12', parent_call_sid: nil, duration: 15) }
    let(:outbound_call) { double(:outbound_call, start_time: Time.zone.now, sid: '9999', parent_call_sid: '12') }

    context 'when pair of calls are passed in' do
      let(:calls) { [inbound_call, outbound_call] }

      it 'returns a call record' do
        call_records = subject.build(calls)
        expect(call_records.count).to eq(1)
        expect(call_records.first).to be_a(described_class)
      end
    end

    context 'when call without a pair is passed' do
      let(:calls) { [inbound_call] }

      it 'no call record is returned' do
        expect(subject.build(calls)).to be_empty
      end

      it 'logs an error' do
        expect(Rails.logger).to receive(:warn).with(
          "Twilio unpaired calls: At: #{start_time} Duration: 15 Sid: 12 ParentSid: "
        )
        subject.build(calls)
      end
    end
  end
end
