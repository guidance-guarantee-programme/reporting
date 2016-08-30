# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DailyCallVolumeCsv do
  let(:separator) { ',' }

  describe '#csv' do
    let(:call_volumes) { CallVolume.new(date: Time.zone.today, daily_call_volumes: [], twilio_call_volumes: []) }
    subject { described_class.new(call_volumes).call.lines }

    it 'generates headings' do
      expect(subject.first.chomp.split(separator)).to match_array(
        %w(
          date
          contact_centre
          twilio
          twilio_cas
          twilio_cita
          twilio_nicab
          twilio_unknown
        )
      )
    end

    context 'data row are correct generated' do
      let(:daily_call_volumes) { [DailyCallVolume.new(date: Time.zone.today, contact_centre: 50, twilio: 100)] }
      let(:twilio_call_volumes) do
        [
          double(delivery_partner: Partners::CAS, count: 10),
          double(delivery_partner: Partners::CITA, count: 80),
          double(delivery_partner: Partners::NICAB, count: 4),
          double(delivery_partner: nil, count: 6)
        ]
      end
      let(:call_volumes) do
        [
          CallVolume.new(
            date: Time.zone.today,
            daily_call_volumes: daily_call_volumes,
            twilio_call_volumes: twilio_call_volumes
          )
        ]
      end

      subject { described_class.new(call_volumes).call.lines }

      it 'generates correctly mapped rows' do
        expect(subject).to include("#{Time.zone.today},50,100,10,80,4,6\n")
      end
    end
  end
end
