require 'rails_helper'
require 'importers'

# rubocop:disable Metrics/BlockLength
RSpec.describe Importers::Twilio::Saver do
  subject { described_class.new(calls: calls) }

  skip '.valid_calls_by_date' do
    let(:date_1) { 1.day.ago }
    let(:date_2) { 2.days.ago }

    context 'when a calls for a single date are passed in' do
      let(:calls) do
        [
          call_record_double(date: date_1),
          call_record_double(date: date_1)
        ]
      end

      it 'creates a daily_call record for that date' do
        expect do
          subject.save
        end.to change { DailyCallVolume.count }.by(1)
      end

      it 'counts the number of calls for the day' do
        subject.save
        expect(DailyCallVolume.last.twilio).to eq(2)
      end

      it 'creates a twilio call for each recoerd' do
        expect do
          subject.save
        end.to change { TwilioCall.count }.by(2)
      end
    end

    context 'when a calls for multiple dates are passed in' do
      let(:calls) do
        [
          call_record_double(date: date_1),
          call_record_double(date: date_2)
        ]
      end

      it 'creates daily_call records for each date' do
        expect do
          subject.save
        end.to change { DailyCallVolume.count }.by(2)
      end
    end

    context 'when invalid calls are passed in' do
      let(:calls) do
        [
          call_record_double(date: date_1, valid?: false),
          call_record_double(date: date_2, valid?: false)
        ]
      end

      it 'they are not saved' do
        expect do
          subject.save
        end.not_to(change { DailyCallVolume.count })
      end
    end

    def call_record_double(overrides = {}) # rubocop:disable Metrics/MethodLength
      defaults = {
        params: {
          uid: SecureRandom.uuid,
          called_at: Time.zone.now,
          inbound_number: 'inbound_number',
          outcome: 'forwarded'
        },
        date: Time.zone.today,
        valid?: true
      }
      double('Importers::Twilio::CallRecord', defaults.merge(overrides)).as_null_object
    end
  end
end
# rubocop:enable Metrics/BlockLength
