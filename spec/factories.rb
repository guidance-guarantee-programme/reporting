FactoryGirl.define do
  factory :year_month do
    transient do
      date { Time.zone.today }
    end
    value { date.strftime('%Y-%m') }
    short_format { date.strftime('%b %Y') }
    start_time { date.beginning_of_month }
    end_time { date.end_of_month }
  end

  factory :appointment_summary do
    delivery_partner { Partners::TPAS }
    source 'automatic'
    year_month { YearMonth.current }
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

  factory :twilio_call do
    uid { SecureRandom.uuid }
    called_at { Time.zone.now }
    cost { BigDecimal('-0.01235') }
    call_duration 45
    inbound_number '+44111111111'
    outbound_number '+44222222222'
    outcome TwilioCall::FORWARDED
    delivery_partner { (Partners.face_to_face + [nil]).sample }
    location_uid { SecureRandom.uuid }
    location 'location'
    location_postcode 'LP12 3AA'
    booking_location 'booking_location'
    booking_location_postcode 'BLP12 3AA'
    hours "Monday to Thursday, 9:30am to 5pm\nFriday, 9:30am to 4:30pm"
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

  factory :cost_item do
    sequence(:name) { |i| "Car-#{i}" }
    cost_group(&:name)
    web_cost false
    current true
    delivery_partner { (Partners.delivery_partners + ['']).sample }
  end

  factory :cost do
    cost_item
    value_delta 100
    user
    forecast false
    year_month { YearMonth.current }
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
