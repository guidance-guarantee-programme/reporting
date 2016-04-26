# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DailyCallVolumeCsv do
  let(:daily_call_volume) do
    DailyCallVolume.new(date: Time.zone.today, source: DailyCallVolume::TWILIO, call_volume: 5)
  end
  let(:separator) { ',' }

  subject { described_class.new(daily_call_volume).call.lines }

  describe '#csv' do
    it 'generates headings' do
      expect(subject.first.chomp.split(separator)).to match_array(
        %w(
          date
          call_volume
        )
      )
    end

    it 'generates correctly mapped rows' do
      expect(subject.last.chomp.split(separator)).to match_array(
        [
          daily_call_volume.date.to_s,
          daily_call_volume.call_volume.to_s
        ]
      )
    end
  end
end
