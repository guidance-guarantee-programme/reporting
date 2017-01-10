require 'rails_helper'

RSpec.describe Costs::Item do
  let(:previous_month) { build_stubbed(:year_month, date: (Time.zone.today << 1)) }
  let(:current_month) { build_stubbed(:year_month) }
  let(:year_months) { [previous_month, current_month] }
  let(:cost_item) { double('CostItem', costs: []) }
  subject { described_class.new(cost_item: cost_item, year_months: year_months) }

  context '#all' do
    it 'returns Costs:MonthItem objects' do
      expect(subject.all.first).to be_a(Costs::MonthItem)
    end

    it 'returns a Costs::MonthItem for each month' do
      expect(subject.all.map(&:year_month)).to eq(year_months)
    end
  end

  context '#for' do
    it 'will return the Costs::MonthItem for the selected month' do
      expect(subject.for(current_month).year_month).to eq(current_month)
    end
  end
end
