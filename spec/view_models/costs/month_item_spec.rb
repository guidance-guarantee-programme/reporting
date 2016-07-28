require 'rails_helper'

RSpec.describe Costs::MonthItem do
  let(:month) { '2016-06' }
  let(:cost_item) { create(:cost_item) }
  subject { described_class.new(cost_item: cost_item, month: month) }

  context '#value' do
    context 'when a single cost entry exists' do
      it 'returns the value of the cost item' do
        create(:cost, month: month, cost_item: cost_item, value_delta: 150)
        expect(subject.value).to eq(150)
      end
    end

    context 'when a multiple cost entry exists' do
      it 'returns the sum of the cost item' do
        create(:cost, month: month, cost_item: cost_item, value_delta: 150)
        create(:cost, month: month, cost_item: cost_item, value_delta: 150)
        create(:cost, month: month, cost_item: cost_item, value_delta: -100)
        expect(subject.value).to eq(200)
      end
    end
  end

  context '#forecast' do
    context 'when a single cost entry exists' do
      it 'returns the forecast flag of the cost item' do
        create(:cost, month: month, cost_item: cost_item, forecast: true)
        expect(subject.forecast).to be_truthy
      end
    end

    context 'when a multiple cost entry exists' do
      it 'returns the forecast flag from the last item (by ID)' do
        create(:cost, month: month, cost_item: cost_item, forecast: true)
        create(:cost, month: month, cost_item: cost_item, forecast: false)
        expect(subject.forecast).to be_falsey
      end
    end
  end
end
