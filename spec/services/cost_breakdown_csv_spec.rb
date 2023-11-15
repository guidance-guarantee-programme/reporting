require 'rails_helper'

RSpec.describe CostBreakdownCsv do
  let(:separator) { ',' }
  let(:jun2016) { double(:year_month, value: '2016-06') }
  let(:jul2016) { double(:year_month, value: '2016-07') }
  let(:month_with_data) { double('data', year_month: jun2016, count: 1, value: 100, forecast: true) }
  let(:month_without_data) { double('data', year_month: jul2016, count: 0) }
  let(:record) do
    double(
      'Costs::Item',
      name: 'Twilio',
      cost_group: 'Contract',
      web_cost: false,
      delivery_partner: '',
      all: [month_with_data, month_without_data]
    )
  end
  let(:months) { [jun2016, jul2016] }
  subject { described_class.new(record, months).call.lines }

  describe '#csv' do
    it 'generates headings' do
      expect(subject.first.chomp.split(separator, -1)).to eq(
        %w[
          name
          cost_group
          web_cost
          delivery_partner
          2016-06
          2016-06_forecast
          2016-07
          2016-07_forecast
        ]
      )
    end

    it 'generates correctly mapped rows' do
      expect(subject.last.chomp.split(separator, -1)).to eq(
        [
          record.name,
          record.cost_group.to_s,
          record.web_cost == 'yes' ? 'Web' : 'Non web',
          record.delivery_partner.presence || '""',
          month_with_data.value.to_s,
          month_with_data.forecast ? 'Yes' : 'No',
          '',
          ''
        ]
      )
    end
  end
end
