require 'rails_helper'
require 'importers'

RSpec.describe Importers::DailyCalls::Twilio::Saver do
  subject { described_class.new(calls: calls) }

  describe '.valid_calls_by_date' do
    let(:date_1) { 1.day.ago }
    let(:date_2) { 2.days.ago }

    context 'when a calls for a single date are passed in' do
      let(:calls) { [double(date: date_1, valid?: true), double(date: date_1, valid?: true)] }

      it 'creates a daily_call record for that date' do
        expect do
          subject.store_valid_by_date
        end.to change { DailyCallVolume.count }.by(1)
      end

      it 'counts the number of calls for the day' do
        subject.store_valid_by_date
        expect(DailyCallVolume.last.twilio).to eq(2)
      end
    end

    context 'when a calls for multiple dates are passed in' do
      let(:calls) { [double(date: date_1, valid?: true), double(date: date_2, valid?: true)] }

      it 'creates daily_call records for each date' do
        expect do
          subject.store_valid_by_date
        end.to change { DailyCallVolume.count }.by(2)
      end
    end

    context 'when invalid calls are passed in' do
      let(:calls) { [double(date: date_1, valid?: false), double(date: date_2, valid?: false)] }

      it 'they are not saved' do
        expect do
          subject.store_valid_by_date
        end.not_to change { DailyCallVolume.count }
      end
    end
  end
end
