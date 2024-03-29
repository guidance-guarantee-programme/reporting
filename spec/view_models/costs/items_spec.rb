require 'rails_helper'

RSpec.describe Costs::Items do
  subject { described_class.new(year_months: year_months) }
  let(:year_months) { [create(:year_month)] }

  context '#all' do
    it 'returns a Costs::Item' do
      create(:cost_item, name: 'apples')
      expect(subject.all.first).to be_a(Costs::Item)
    end

    it 'returns a Costs::Item for each active cost_item' do
      create(:cost_item, name: 'apples')
      create(:cost_item, name: 'bananas')
      create(:cost_item, name: 'bread', current: false)

      expect(subject.all.map(&:name)).to eq(%w[apples bananas])
    end

    it 'returns a Costs::Item for inactive cost items with data in the month' do
      bread = create(:cost_item, name: 'bread', current: false)
      create(:cost, cost_item: bread, year_month: year_months.first)

      expect(subject.all.map(&:name)).to eq(['bread'])
    end

    it 'does not return a Costs::Item for inactive costs with data outside the month' do
      bread = create(:cost_item, name: 'bread', current: false)
      create(:cost, cost_item: bread, year_month: create(:year_month, date: 1.month.ago))

      expect(subject.all.map(&:name)).to be_empty
    end
  end
end
