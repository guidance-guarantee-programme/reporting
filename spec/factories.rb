FactoryGirl.define do
  factory :where_did_you_hear do
    given_at { Time.zone.now }
    delivery_partner { %w(TPAS NICAB CAS TP).sample }
    sequence(:where_code) { |i| "WDYH_#{i}" }
    where 'Pension Provider'
    sequence(:pension_provider_code) { |i| "PP_#{i}" }
    pension_provider 'Hargreaves Lansdown'
    location 'Belfast'

    before(:create) do |a|
      create(:code_lookup, from: a.pension_provider_code, to: a.pension_provider)
      create(:code_lookup, from: a.where_code, to: a.where)
    end
  end

  factory :code_lookup do
    from 'PP_HL'
    to 'Hargreaves Lansdown'
  end
end
