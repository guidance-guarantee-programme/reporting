require 'rails_helper'

RSpec.describe WhereDidYouHears do
  subject { described_class.new(page: nil, start_date: nil, end_date: nil) }

  context 'when initializing' do
    it 'defaults the start and end dates' do
      expect(subject.start_date).to eq(1.month.ago.to_date)
      expect(subject.end_date).to eq(Time.zone.today)
    end
  end

  describe '#start_date and #end_date' do
    context 'with a datetime, when presenting' do
      it 'strips the time portion so the field can be bound to an HTML5 date picker' do
        subject.start_date = subject.end_date = Time.zone.parse('2016-01-01 00:00:00 UTC')

        expect(subject.start_date.to_s).to eq('2016-01-01')
        expect(subject.end_date.to_s).to eq('2016-01-01')
      end
    end
  end

  describe '#paginated_results' do
    let(:page_size_plus_one) { Kaminari.config.default_per_page + 1 }

    it 'returns results within the provided date range' do
      present = create(:where_did_you_hear, given_at: Time.zone.today)
      create(:where_did_you_hear, given_at: 1.year.ago)

      expect(subject.paginated_results).to match_array(present)
    end

    it 'is paginated' do
      create_list(:where_did_you_hear, page_size_plus_one)

      expect(subject.paginated_results.size).to eq(Kaminari.config.default_per_page)
    end
  end
end
