require 'rails_helper'

RSpec.describe Costs::Item do
  let(:months) { ['2016-05', '2016-06'] }
  let(:cost_item) { double('CostItem') }
  subject { described_class.new(cost_item: cost_item, months: months) }

  context '#all' do
    it 'returns Costs:MonthItem objects' do
      expect(subject.all.first).to be_a(Costs::MonthItem)
    end

    it 'returns a Costs::MonthItem for each month' do
      expect(subject.all.map(&:month)).to eq(months)
    end
  end

  context '#for' do
    it 'will return the Costs::MonthItem for the selected month' do
      expect(subject.for('2016-06').month).to eq('2016-06')
    end
  end
end
