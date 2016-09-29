require 'rails_helper'

RSpec.describe CostBreakdownRawCsv do
  let(:separator) { ',' }
  let(:record) { build_stubbed(:cost, created_at: Time.zone.now) }
  subject { described_class.new(record).call.lines }

  describe '#csv' do
    it 'generates headings' do
      expect(subject.first.chomp.split(separator, -1)).to eq(
        %w(
          name
          cost_group
          web_cost
          delivery_partner
          month
          value_delta
          forecast
          created_at
        )
      )
    end

    it 'generates correctly mapped rows' do
      expect(subject.last.chomp.split(separator, -1)).to eq(
        [
          record.cost_item.name,
          record.cost_item.cost_group.to_s,
          record.cost_item.web_cost ? 'yes' : 'no',
          record.cost_item.delivery_partner.presence || '""',
          record.year_month.value,
          record.value_delta.to_s,
          record.forecast.to_s,
          record.created_at.strftime('%Y-%m-%d')
        ]
      )
    end
  end
end
