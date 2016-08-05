require 'rails_helper'

RSpec.describe AppointmentSummary, type: :model do
  it { is_expected.to validate_inclusion_of(:source).in_array(%w(automatic manual)) }
  it { is_expected.to validate_inclusion_of(:delivery_partner).in_array(Partners.delivery_partners) }
  [nil, 0, 100, 1_000_000].each do |transactions|
    context "when transactiosn is: #{transactions}" do
      subject { described_class.new(transactions: transactions) }
      it { is_expected.to validate_inclusion_of(:completions).in_range(0..transactions.to_i) }
    end
  end
  it { is_expected.to validate_numericality_of(:transactions).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:bookings).is_greater_than_or_equal_to(0) }
end
