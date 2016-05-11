require 'rails_helper'

RSpec.describe WhereDidYouHearCsv do
  let(:record) { build_stubbed(:where_did_you_hear, where_raw: 'Pension Provider') }
  let(:separator) { ',' }

  subject { described_class.new(record).call.lines }

  describe '#csv' do
    it 'generates headings' do
      expect(subject.first.chomp.split(separator)).to match_array(
        %w(
          id
          given_at
          delivery_partner
          where_raw
          where_code
          where
          pension_provider
          location
        )
      )
    end

    it 'generates correctly mapped rows' do
      expect(subject.last.chomp.split(separator)).to match_array(
        [
          record.to_param,
          record.given_at.to_s,
          record.delivery_partner,
          record.where_raw,
          record.where_code,
          record.where,
          record.pension_provider,
          record.location
        ]
      )
    end
  end
end
