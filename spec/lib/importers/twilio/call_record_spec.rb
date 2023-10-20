require 'rails_helper'
require 'importers'

RSpec.describe Importers::Twilio::CallRecord, :vcr do
  subject { described_class }

  describe '.build' do
    let(:start_time) { Time.zone.now }
    let(:twilio_lookup) { double('Importers::Twilio::TwilioLookup', call: {}) }
    let(:inbound_call) { build_call_double('inbound', start_time: start_time, sid: '12') }
    let(:outbound_call) { build_call_double('outbound', sid: '9999', parent_call_sid: '12') }

    context 'when pair of calls are passed in' do
      let(:calls) { [inbound_call, outbound_call] }

      it 'builds a call record' do
        call_records = subject.build(calls: calls, twilio_lookup: twilio_lookup)
        expect(call_records.count).to eq(1)
        expect(call_records.first).to be_a(described_class)
      end
    end

    context 'when inbound call without a pair' do
      let(:calls) { [inbound_call] }

      it 'builds a failed call record' do
        call_records = subject.build(calls: calls, twilio_lookup: twilio_lookup)
        expect(call_records.count).to eq(1)
        expect(call_records.first.outcome).to eq('failed')
      end
    end

    context 'when outbound call without a pair' do
      let(:calls) { [outbound_call] }

      it 'no call record is returned' do
        expect(subject.build(calls: calls, twilio_lookup: twilio_lookup)).to be_empty
      end

      it 'logs an error' do
        expect(Rails.logger).to receive(:warn).with(
          "Twilio unpaired calls (1): At: #{start_time} Duration: 15 Sid: 9999 ParentSid: 12"
        )
        subject.build(calls: calls, twilio_lookup: twilio_lookup)
      end
    end

    def build_call_double(direction, overrides = {})
      params = { direction: direction, start_time: Time.zone.now, duration: 15 }
      double(:call, params.merge(overrides)).as_null_object
    end
  end

  describe '#cost' do
    subject { described_class.new([inbound_call, outbound_call], {}) }
    let(:inbound_call) { double(:inbound, price: '-0.00750') }

    context 'when an outbound exists' do
      let(:outbound_call) { double(:outbound, price: '-0.00375') }

      it 'sums the outbound and inbound costs' do
        expect(subject.cost).to eq(BigDecimal('-0.01125'))
      end
    end

    context 'when no outbound call exists' do
      let(:outbound_call) { nil }

      it 'takes the inbound call cost only' do
        expect(subject.cost).to eq(BigDecimal('-0.00750'))
      end
    end

    context 'when an outbound call has no price (when the duration is 0)' do
      let(:outbound_call) { double(:outbound, price: nil) }

      it 'takes the inbound call cost only' do
        expect(subject.cost).to eq(BigDecimal('-0.00750'))
      end
    end
  end

  describe '#caller_phone_number' do
    subject { described_class.new([inbound_call, double(:outbound_call)], {}) }
    let(:inbound_call) { double(:inbound, from: caller_phone_number) }

    context 'when the caller is using an anonymous number' do
      let(:caller_phone_number) { '+266696687' }

      it 'returns nil' do
        expect(subject.caller_phone_number).to be_nil
      end
    end

    context 'when the caller is not using an anonymous number' do
      let(:caller_phone_number) { '+44123456789' }

      it 'returns the callers phone number' do
        expect(subject.caller_phone_number).to eq(caller_phone_number)
      end
    end
  end
end
