require 'rails_helper'

RSpec.describe TwilioCall, type: :model do
  it { is_expected.to validate_inclusion_of(:delivery_partner).in_array(Partners.face_to_face).allow_blank }
  it { is_expected.to validate_inclusion_of(:outcome).in_array(%w(forwarded abandoned failed)) }
  it { is_expected.to validate_presence_of(:uid) }
  it { is_expected.to validate_presence_of(:inbound_number) }
  it { is_expected.to validate_presence_of(:called_at) }

  it { is_expected.to have_db_column(:cost).with_options(scale: 5) }
end
