# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DailyCallVolumeCsv do
  let(:separator) { ',' }

  describe '#csv' do
    subject { described_class.new(DailyCallVolume.new).call.lines }

    it 'generates headings' do
      expect(subject.first.chomp.split(separator)).to match_array(
        %w(
          date
          twilio
          contact_centre
        )
      )
    end

    context 'data row are correct generated' do
      let(:daily_call_volumes) { [DailyCallVolume.new(date: Time.zone.today, contact_centre: 50, twilio: 100)] }

      subject { described_class.new(daily_call_volumes).call.lines }

      it 'generates correctly mapped rows' do
        expect(subject).to include("#{Time.zone.today},100,50\n")
      end
    end
  end
end
