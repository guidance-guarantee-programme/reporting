require 'rails_helper'

RSpec.describe TwilioCallsCsv do
  let(:separator) { ',' }

  describe '#csv' do
    subject { described_class.new(TwilioCall.new).call.lines }

    it 'generates headings' do
      expect(subject.first.chomp.split(separator, -1)).to match_array(
        %w[
          called_at
          outcome
          outbound_call_outcome
          call_duration
          cost
          inbound_number
          outbound_number
          caller_phone_number
          location_uid
          location
          location_postcode
          booking_location
          booking_location_postcode
          delivery_partner
          hours
        ]
      )
    end

    context 'data row are correct generated' do
      let(:record) { build_stubbed(:twilio_call) }
      subject { described_class.new(record).call.lines }

      it 'generates correctly mapped rows' do
        expect(subject.last.chomp.split(separator, -1)).to eq(
          [
            record.called_at.strftime('%Y-%m-%d %H:%M:%S'),
            record.outcome,
            record.outbound_call_outcome,
            record.call_duration.to_s,
            record.cost.to_s,
            record.inbound_number,
            record.outbound_number,
            record.caller_phone_number,
            record.location_uid,
            record.location,
            record.location_postcode,
            record.booking_location,
            record.booking_location_postcode,
            record.delivery_partner.to_s,
            'Monday to Thursday - 9:30am to 5pm; Friday - 9:30am to 4:30pm'
          ]
        )
      end
    end
  end
end
