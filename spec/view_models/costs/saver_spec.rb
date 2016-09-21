require 'rails_helper'

RSpec.describe Costs::Saver do
  let(:cost_item) { create(:cost_item) }
  let(:user) { create(:user) }
  let(:month) { Time.zone.today.strftime('%Y-%m') }
  let(:costs_items) { Costs::Items.new(months: [month]) }
  subject { described_class.new(costs_items: costs_items, user: user) }

  context 'when no data data exists for the cost_item' do
    it 'creates cost records when the value changes' do
      params = {
        month: month,
        costs: {
          cost_item.id => { value: '100', forecast: '0' }
        }
      }

      expect { subject.save(params) }.to change { Cost.count }.by(1)

      expect(Cost.last).to have_attributes(
        cost_item_id: cost_item.id,
        value_delta: 100,
        forecast: false,
        user_id: user.id,
        month: month
      )
    end

    it 'ignores changes to the forecast flag when value is 0' do
      params = {
        month: month,
        costs: {
          cost_item.id => { value: '0', forecast: '1' }
        }
      }

      expect { subject.save(params) }.not_to change { Cost.count }
    end
  end

  context 'when cost data already exists for the cost_item' do
    before do
      create(:cost, cost_item: cost_item, value_delta: 75, forecast: true)
    end

    it 'creates cost records when the value changes' do
      params = {
        month: month,
        costs: {
          cost_item.id => { value: '100', forecast: '0' }
        }
      }

      expect { subject.save(params) }.to change { Cost.count }.by(1)

      expect(Cost.last).to have_attributes(
        cost_item_id: cost_item.id,
        value_delta: 25,
        forecast: false,
        user_id: user.id,
        month: month
      )
    end

    it 'will modify the last record if the forecast flag changes without the value changing' do
      params = {
        month: month,
        costs: {
          cost_item.id => { value: '75', forecast: '0' }
        }
      }

      expect { subject.save(params) }.not_to change { Cost.count }

      expect(Cost.last).to have_attributes(
        cost_item_id: cost_item.id,
        value_delta: 75,
        forecast: false,
        user_id: user.id,
        month: month
      )
    end
  end
end
