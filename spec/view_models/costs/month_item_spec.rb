require 'rails_helper'

RSpec.describe Costs::MonthItem do
  let(:year_month) { build_stubbed(:year_month) }
  let(:cost_item) { build_stubbed(:cost_item) }
  subject { described_class.new(cost_item: cost_item, year_month: year_month, costs: costs) }

  context '#value' do
    context 'when a single cost entry exists' do
      let(:costs) { [build_stubbed(:cost, value_delta: 150)] }

      it 'returns the value of the cost item' do
        expect(subject.value).to eq(150)
      end
    end

    context 'when a multiple cost entry exists' do
      let(:costs) {
        [
          build_stubbed(:cost, value_delta: 150),
          build_stubbed(:cost, value_delta: 150),
          build_stubbed(:cost, value_delta: -100)
        ]
      }

      it 'returns the sum of the cost item' do
        expect(subject.value).to eq(200)
      end
    end
  end

  context '#forecast' do
    context 'when a single cost entry exists' do
      let(:costs) { [build_stubbed(:cost, forecast: true)] }

      it 'returns the forecast flag of the cost item' do
        expect(subject.forecast).to be_truthy
      end
    end

    context 'when a multiple cost entry exists' do
      let(:costs) {
        [
          build_stubbed(:cost, forecast: true),
          build_stubbed(:cost, forecast: false)
        ]
      }

      it 'returns the forecast flag from the last item (by ID)' do
        expect(subject.forecast).to be_falsey
      end
    end
  end
end
