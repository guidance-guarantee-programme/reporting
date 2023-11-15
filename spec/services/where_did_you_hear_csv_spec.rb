require 'rails_helper'

RSpec.describe WhereDidYouHearCsv do
  let(:record) { build_stubbed(:where_did_you_hear, heard_from_raw: 'Pension Provider') }
  let(:separator) { ',' }

  subject { described_class.new(record).call.lines }

  describe '#csv' do
    it 'generates headings' do
      expect(subject.first.chomp.split(separator)).to match_array(
        %w[
          id
          given_at
          delivery_partner
          heard_from_raw
          heard_from_code
          heard_from
          pension_provider
          location
        ]
      )
    end

    it 'generates correctly mapped rows' do
      expect(subject.last.chomp.split(separator)).to match_array(
        [
          record.to_param,
          record.given_at.to_s,
          record.delivery_partner,
          record.heard_from_raw,
          record.heard_from_code,
          record.heard_from,
          record.pension_provider,
          record.location
        ]
      )
    end
  end
end
