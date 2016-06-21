require 'rails_helper'
require 'importers'

RSpec.describe Importers::BookingBug::Record do
  describe '#booking_status' do
    it 'retrieves the value from the answers that are passed in' do
      record = described_class.new(
        '_embedded' => {
          'answers' => [
            { 'question_text' => 'Booking', 'value' => 'Complete' }
          ]
        }
      )

      expect(record.booking_status).to eq('Complete')
    end

    it 'uses the default when no value is passed in' do
      record = described_class.new(
        '_embedded' => {
          'answers' => []
        }
      )

      expect(record.booking_status).to eq(described_class::DEFAULT_BOOKING_STATUS)
    end

    it 'uses the default when an empty string is passed in' do
      record = described_class.new(
        '_embedded' => {
          'answers' => [
            { 'question_text' => 'Booking', 'value' => '' }
          ]
        }
      )

      expect(record.booking_status).to eq(described_class::DEFAULT_BOOKING_STATUS)
    end
  end
end
