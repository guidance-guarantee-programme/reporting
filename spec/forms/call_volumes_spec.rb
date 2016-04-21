require 'rails_helper'

RSpec.describe CallVolumes do
  describe 'initilaize' do
    context 'when no start date is passed in' do
      subject { described_class.new(start_date: nil, end_date: nil) }

      it 'sets the start date to the beginning of the month' do
        expect(subject.start_date).to eq(Time.zone.today.beginning_of_month)
      end
    end

    context 'when no end date is passed in' do
      subject { described_class.new(start_date: nil, end_date: nil) }

      it 'sets the start date to the beginning of the month' do
        expect(subject.end_date).to eq(Time.zone.today)
      end
    end

    context 'when a start and end date is passed in' do
      subject { described_class.new(start_date: '2016-03-01', end_date: '2016-03-31') }

      it 'sets the start date from the date string' do
        expect(subject.start_date).to eq(Date.new(2016, 3, 1))
      end

      it 'sets the end date from the date string' do
        expect(subject.end_date).to eq(Date.new(2016, 3, 31))
      end
    end
  end

  describe '#results' do
    let(:date) { Time.zone.today.to_s }
    subject { described_class.new(start_date: date, end_date: date) }

    context 'when daily call data exists for the selected date raneg' do
      let!(:daily_call) { DailyCallVolume.create!(date: date, call_volume: 1, source: DailyCallVolume::TWILIO) }

      it 'returns the daily call records for the period' do
        expect(subject.results).to eq([daily_call])
      end
    end

    context 'when nothing has been persisted for the selected date range' do
      it 'returns a date' do
        result_for_day = subject.results.first
        expect(result_for_day.date).to eq(Time.zone.today)
      end

      it 'returns call volume of 0' do
        result_for_day = subject.results.first
        expect(result_for_day.call_volume).to eq(0)
      end
    end
  end
end
