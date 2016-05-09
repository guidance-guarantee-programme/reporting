require 'rails_helper'
require 'importers'

RSpec.feature 'Importing twilio call data', vcr: { cassette_name: 'twilio_single_page_of_data' } do
  let(:start_date) { Date.new(2016, 4, 11) }
  let(:end_date) { Date.new(2016, 4, 12) }
  let(:twilio_config) { double(:config, twilio: double(account_sid: 'ACCOUNT_SID', auth_token: 'AUTH_TOKEN')) }

  before do
    allow(Rails.configuration).to receive(:x).and_return(twilio_config)
  end

  scenario 'Storing daily call volumes for use in the Minister For Pensions report' do
    when_i_import_twilio_data
    then_the_daily_call_volume_for_twilio_should_be_saved
  end

  scenario 'Updating daily call volumes' do
    given_old_daily_call_volumes_exists
    when_i_import_twilio_data
    then_the_daily_call_volume_for_twilio_should_be_updated
  end

  def given_old_daily_call_volumes_exists
    @daily_call = DailyCallVolume.create!(
      date: Date.new(2016, 4, 11),
      twilio: 10
    )
  end

  def when_i_import_twilio_data
    Importers::DailyCalls::Twilio::Importer.new.import(start_date: start_date, end_date: end_date)
  end

  def then_the_daily_call_volume_for_twilio_should_be_saved
    expect(DailyCallVolume.count).to eq(1)
    expect(DailyCallVolume.first).to have_attributes(
      date: Date.new(2016, 4, 11),
      twilio: 1,
      tp: 0
    )
  end

  def then_the_daily_call_volume_for_twilio_should_be_updated
    @daily_call.reload
    expect(@daily_call.twilio).to eq(1)
  end
end
