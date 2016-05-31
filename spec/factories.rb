FactoryGirl.define do
  factory :satisfaction do
    sequence(:uid) { |i| "<delivery_partner>:#{i}" }
    given_at { Time.zone.now }
    delivery_partner { DeliveryPartner.face_to_face.sample }
    satisfaction { rand(4).to_i }
  end

  factory :where_did_you_hear do
    given_at { Time.zone.now }
    delivery_partner { DeliveryPartner.all.sample }
    sequence(:heard_from_code) { |i| "WDYH_#{i}" }
    heard_from 'Pension Provider'
    sequence(:pension_provider_code) { |i| "PP_#{i}" }
    pension_provider 'Hargreaves Lansdown'
    location 'Belfast'

    before(:create) do |a|
      create(:code_lookup, from: a.pension_provider_code, to: a.pension_provider)
      create(:code_lookup, from: a.heard_from_code, to: a.heard_from)
    end
  end

  factory :code_lookup do
    from 'PP_HL'
    to 'Hargreaves Lansdown'
  end
end
