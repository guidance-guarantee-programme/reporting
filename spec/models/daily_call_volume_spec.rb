require 'rails_helper'

RSpec.describe DailyCallVolume, type: :model do
  it { is_expected.to validate_presence_of(:source) }
  it { is_expected.to validate_inclusion_of(:source).in_array(%w(twilio)) }
  it { is_expected.to validate_presence_of(:date) }
  it { is_expected.to validate_uniqueness_of(:date).scoped_to(:source) }
  it { is_expected.to validate_presence_of(:call_volume) }
end
