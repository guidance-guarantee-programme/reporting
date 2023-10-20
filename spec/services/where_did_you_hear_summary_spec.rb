require 'rails_helper'

RSpec.describe WhereDidYouHearSummary do
  before do
    create_list(:where_did_you_hear, 5, heard_from: 'Internet')
    create_list(:where_did_you_hear, 5, heard_from: 'Pension Provider')
    create_list(:where_did_you_hear, 1, heard_from: 'Other')
  end

  subject { described_class.new(WhereDidYouHear.all) }

  describe '#rows' do
    it 'returns mapped rows grouped by `heard_from`' do
      row = subject.rows.sort_by(&:heard_from).first

      expect(row.heard_from).to eq('Internet')
      expect(row.count).to eq(5)
      expect(row.total).to eq(11)
      expect(row.percentage).to eq(45.45454545454545)
    end

    it 'is ordered by `count` descending' do
      expect(subject.rows.map(&:count)).to eq([5, 5, 1])
    end
  end

  describe '#total' do
    it 'returns the total number of entries' do
      expect(subject.total).to eq(11)
    end
  end

  describe WhereDidYouHearSummary::Row, '#heard_from' do
    subject { described_class.new(heard_from: '', count: 0, total: 0) }

    context 'when `heard_from` is not present' do
      it 'returns the N / A label' do
        expect(subject.heard_from).to eq('N / A')
      end
    end
  end
end
