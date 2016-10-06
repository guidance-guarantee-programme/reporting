require 'rails_helper'

RSpec.describe YearMonth, type: :model do
  describe '.find_or_build' do
    it 'returns the existing record if one exists' do
      month = create(:year_month)
      expect(described_class.find_or_build(year: Time.zone.today.year, month: Time.zone.today.month)).to eq(month)
    end

    it 'creates a new year month object if none exists' do
      expect {
        described_class.find_or_build(year: Time.zone.today.year, month: Time.zone.today.month)
      }.to change { described_class.count }.by(1)
    end
  end

  describe '.current' do
    it 'returns the year_month object for the current month' do
      month = create(:year_month)
      expect(described_class.current).to eq(month)
    end

    it 'creates a new object if none exists for the current month' do
      expect { described_class.current }.to change { described_class.count }.by(1)
    end
  end

  describe '.between' do
    let!(:months) { (-3..3).map { |offset| create(:year_month, date: Time.zone.today >> offset) } }

    it 'returns all the months between specified start and end month' do
      start_month = rand(5)
      end_month = rand(6 - start_month) + start_month
      expect(
        described_class.between(months[start_month], months[end_month])
      ).to eq(months[start_month..end_month])
    end
  end

  describe '#around' do
    let!(:months) { (-3..3).map { |offset| create(:year_month, date: Time.zone.today >> offset) } }

    it 'returns the range of months starting 3 months before and ending 1 month after' do
      expect(months[4].around).to eq(months[1..5])
    end
  end
end
