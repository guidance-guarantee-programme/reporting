require 'rails_helper'

RSpec.describe Satisfaction, type: :model do
  subject { create(:satisfaction) }

  it { is_expected.to validate_presence_of(:uid) }
  it { is_expected.to validate_uniqueness_of(:uid) }
  it { is_expected.to validate_presence_of(:given_at) }
  it { is_expected.to validate_inclusion_of(:delivery_partner).in_array(%w(cas cita nicab)) }
  it do
    is_expected.to validate_numericality_of(:satisfaction)
      .is_greater_than_or_equal_to(0)
      .is_less_than_or_equal_to(4)
      .only_integer
  end
end
