require 'rails_helper'
require 'importers'

RSpec.feature 'Importing twilio call data', vcr: { cassette_name: 'twilio_single_page_of_data' } do
  let(:start_date) { Date.new(2016, 4, 11) }
  let(:end_date) { Date.new(2016, 4, 12) }
  let(:config) { double(account_sid: 'ACCOUNT_SID', auth_token: 'AUTH_TOKEN') }
  let(:call_params) do
    {
      uid: 'CA7eb4d3924e3e73e9ef0dcad70b3b46fa',
      inbound_number: 'inbound',
      outbound_number: 'outbound',
      caller_phone_number: 'caller_phone_number',
      call_duration: 24,
      called_at: Time.zone.parse('2016-08-20 11:26:35'),
      cost: -0.015,
      outcome: 'forwarded',
      delivery_partner: 'cita',
      location_uid: 'uid',
      location: 'location',
      location_postcode: 'location_postcode',
      booking_location: 'booking_location',
      booking_location_postcode: 'booking_location_postcode'
    }
  end

  scenario 'Storing daily call volumes for use in the Minister For Pensions report' do
    when_i_import_twilio_data
    then_the_daily_call_volume_for_twilio_should_be_saved
  end

  scenario 'Storing call records' do
    when_i_import_twilio_data
    then_twilio_call_data_should_be_created
  end

  scenario 'Storing call records with location details' do
    given_location_details_exist
    when_i_import_twilio_data
    then_twilio_call_data_should_be_created
  end

  scenario 'Updating daily call volumes' do
    given_old_daily_call_volumes_exists
    when_i_import_twilio_data
    then_the_daily_call_volume_for_twilio_should_be_updated
  end

  scenario 'It does not update existsing call records' do
    given_a_call_record_exists
    when_i_import_twilio_data
    only_the_call_records_twilio_values_have_been_changed
  end

  def given_old_daily_call_volumes_exists
    @daily_call = DailyCallVolume.create!(
      date: Date.new(2016, 4, 11),
      twilio: 10
    )
  end

  def given_location_details_exist
    @twilio_lookup_response = {
      'uid' => 'c002c214-7a39-4ff2-b21f-a4f3b45b14a1',
      'delivery_partner' => 'cas',
      'location' => 'Aberdeen',
      'location_postcode' => 'AB11 5BN',
      'booking_location' => 'Aberdeen',
      'booking_location_postcode' => 'AB11 5BN'
    }
  end

  def given_a_call_record_exists
    TwilioCall.create!(call_params)
  end

  def when_i_import_twilio_data
    Importers::Twilio::Importer.new(
      config: config,
      twilio_lookup: double('Importers::Twilio::TwilioLookup', call: twilio_lookup_response)
    ).import(start_date: start_date, end_date: end_date)
  end

  def then_the_daily_call_volume_for_twilio_should_be_saved
    expect(DailyCallVolume.count).to eq(1)
    expect(DailyCallVolume.first).to have_attributes(
      date: Date.new(2016, 4, 11),
      twilio: 1,
      contact_centre: 0
    )
  end

  def then_twilio_call_data_should_be_created # rubocop:disable Metrics/MethodLength
    expect(TwilioCall.count).to eq(1)
    expect(TwilioCall.first).to have_attributes(
      twilio_lookup_response.slice(
        'delivery_partner',
        'location',
        'location_postcode',
        'booking_location',
        'booking_location_postcode'
      ).merge(
        uid: 'CA7eb4d3924e3e73e9ef0dcad70b3b46fa',
        inbound_number: '+441794840107',
        outbound_number: '+441794840107',
        caller_phone_number: '+1111111111',
        call_duration: 12,
        called_at: Time.zone.parse('2016-04-11 14:03:35'),
        cost: -0.015,
        outcome: 'forwarded',
        outbound_call_outcome: 'completed',
        location_uid: twilio_lookup_response['uid']
      )
    )
  end

  def then_the_daily_call_volume_for_twilio_should_be_updated
    @daily_call.reload
    expect(@daily_call.twilio).to eq(1)
  end

  def only_the_call_records_twilio_values_have_been_changed
    twilio_data_fields = %i(inbound_number outbound_number caller_phone_number call_duration called_at cost outcome)
    location_fields = %i(delivery_partner location_uid location location_postcode booking_location
                         booking_location_postcode)
    expect(TwilioCall.last).not_to have_attributes(call_params.slice(twilio_data_fields))
    expect(TwilioCall.last).to have_attributes(call_params.slice(location_fields))
  end

  def twilio_lookup_response
    @twilio_lookup_response || {}
  end
end
