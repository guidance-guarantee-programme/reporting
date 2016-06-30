FactoryGirl.define do
  factory :appointment_summary do
    delivery_partner { Partners::TPAS }
    source 'automatic'
  end

  factory :appointment do
    uid '12345'
    booked_at '2016-06-10 11:52:40'
    booking_at '2016-06-10 11:52:40'
    transaction_at '2016-06-10 11:52:40'
    cancelled false
    booking_status 'Incomplete'
    delivery_partner { Partners::TPAS }
  end

  factory :satisfaction do
    sequence(:uid) { |i| "<delivery_partner>:#{i}" }
    given_at { Time.zone.now }
    delivery_partner { Partners.face_to_face.sample }
    satisfaction { rand(4).to_i }
  end

  factory :where_did_you_hear do
    given_at { Time.zone.now }
    delivery_partner { Partners.callable_delivery_partners.sample }
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

  factory :uploaded_file do
    upload_type 'cita_appointments'
    processed false
    filename 'cita_appointments.csv'
  end

  factory :user do
    name 'Data analyst'
    email 'analyst@pensionwise.gov.uk'
    uid SecureRandom.uuid
    permissions []
    remotely_signed_out false
    disabled false
  end
end
