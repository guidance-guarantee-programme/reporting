require 'rails_helper'

RSpec.describe DailyCallVolume, type: :model do
  it { is_expected.to validate_presence_of(:date) }
  it { is_expected.to validate_uniqueness_of(:date) }
  it { is_expected.to validate_numericality_of(:twilio).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:twilio).is_greater_than_or_equal_to(0) }
end
