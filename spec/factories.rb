FactoryGirl.define do
  factory :where_did_you_hear do
    given_at { Time.zone.now }
    delivery_partner { %w(TPAS NICAB CAS TP).sample }
    where 'Pension Provider'
    pension_provider 'Hargreaves Lansdown'
    location 'Belfast'
  end
end
