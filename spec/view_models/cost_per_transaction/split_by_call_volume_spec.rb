require 'rails_helper'

RSpec.describe CostPerTransaction::SplitByCallVolume do
  let(:year_month) { build_stubbed(:year_month) }
  subject { described_class.new(year_month) }

  it 'allocates cost based on call volume' do
    create_list(:twilio_call, 4, delivery_partner: 'cita')
    create_list(:twilio_call, 2, delivery_partner: 'cas')
    create_list(:twilio_call, 1, delivery_partner: 'nicab')

    expect(subject.call(700)).to eq(
      'cita' => 400.0,
      'cas' => 200.0,
      'nicab' => 100.0
    )
  end

  it 'correctly rounds values to the nearest cent' do
    create_list(:twilio_call, 1, delivery_partner: 'cita')
    create_list(:twilio_call, 1, delivery_partner: 'cas')
    create_list(:twilio_call, 1, delivery_partner: 'nicab')

    expect(subject.call(10)).to eq(
      'cita' => 3.33,
      'cas' => 3.33,
      'nicab' => 3.34
    )
  end

  it 'uses call volumes from a future month if no data exists for the current month' do
    create_list(:twilio_call, 1, delivery_partner: 'cita', called_at: 1.month.from_now)
    create_list(:twilio_call, 1, delivery_partner: 'cas', called_at: 1.month.from_now)
    create_list(:twilio_call, 1, delivery_partner: 'nicab', called_at: 1.month.from_now)

    expect(subject.call(10)).to eq(
      'cita' => 3.33,
      'cas' => 3.33,
      'nicab' => 3.34
    )
  end

  it 'uses call volumes from a previous month if no data exists from the current month until infinity' do
    create_list(:twilio_call, 1, delivery_partner: 'cita', called_at: 1.month.ago)
    create_list(:twilio_call, 1, delivery_partner: 'cas', called_at: 1.month.ago)
    create_list(:twilio_call, 1, delivery_partner: 'nicab', called_at: 1.month.ago)

    expect(subject.call(10)).to eq(
      'cita' => 3.33,
      'cas' => 3.33,
      'nicab' => 3.34
    )
  end
end
