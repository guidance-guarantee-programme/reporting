require 'rails_helper'

RSpec.describe CostPerTransaction::CostByDeliveryPartner do
  subject { described_class.new(costs_by_partner, '09-2016') }

  context 'when only simple costs are present' do
    let(:costs_by_partner) { { 'cita' => 100, 'cas' => 5 } }

    it 'returns the map of partner to cost' do
      expect(subject.call).to eq(costs_by_partner)
    end
  end

  context 'when complex costs are present' do
    before do
      allow(CostPerTransaction::SplitByCallVolume).to receive(:new).and_return(fake_splitter)
    end
    let(:costs_by_partner) { { 'cita' => 100, 'cas' => 5, 'split_by_call_volume' => 50 } }
    let(:fake_splitter) { double(:fake_spliter, call: { 'cita' => 30, 'cas' => 10, 'nicab' => 10 }) }

    it 'splits the costs by delivery partner and adds then todether' do
      expect(subject.call).to eq(
        'cita' => 130,
        'cas' => 15,
        'nicab' => 10
      )
    end
  end
end
