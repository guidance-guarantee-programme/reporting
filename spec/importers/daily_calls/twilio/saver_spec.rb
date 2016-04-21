require 'rails_helper'

RSpec.describe DailyCalls::Twilio::Saver do
  subject { described_class }

  describe '.valid_calls_by_date' do
    let(:date_1) { 1.day.ago }
    let(:date_2) { 2.days.ago }

    context 'when a calls for a single date are passed in' do
      it 'creates a daily_call record for that date' do
        expect do
          subject.valid_calls_by_date([double(date: date_1, valid?: true)])
        end.to change { DailyCall.count }.by(1)
      end

      it 'counts the number of calls for the day' do
        subject.valid_calls_by_date([double(date: date_1, valid?: true), double(date: date_1, valid?: true)])
        expect(DailyCall.last.call_volume).to eq(2)
      end
    end

    context 'when a calls for multiple dates are passed in' do
      it 'creates daily_call records for each date' do
        expect do
          subject.valid_calls_by_date([double(date: date_1, valid?: true), double(date: date_2, valid?: true)])
        end.to change { DailyCall.count }.by(2)
      end
    end

    context 'when invalid calls are passed in' do
      it 'they are not saved' do
        expect do
          subject.valid_calls_by_date([double(date: date_1, valid?: false), double(date: date_2, valid?: false)])
        end.not_to change { DailyCall.count }
      end
    end
  end
end
