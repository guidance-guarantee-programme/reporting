require 'rails_helper'

RSpec.describe CostPerTransaction::SplitByCallVolume do
  subject { described_class.new(Time.zone.today.strftime('%m-%Y')) }

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
end
