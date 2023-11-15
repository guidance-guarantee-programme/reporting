require 'rails_helper'
require 'importers'

RSpec.feature 'Importing session data', vcr: { cassette_name: 'google_session_data' } do
  let(:test_user) { 'reporting-testing@pension-wise.iam.gserviceaccount.com' }
  let(:test_key) { File.read(Rails.root.join('spec/fixtures/reporting-testing-key.txt')) }

  scenario 'via google spreadsheets' do
    skip 'Temporarily skip'
    given_i_have_a_configured_google_account
    when_i_import_google_session_data
    then_web_transaction_data_has_been_saved
  end

  def given_i_have_a_configured_google_account
    Rails.configuration.x.google_sessions.tap do |satisfaction|
      satisfaction.service_account_email = test_user
      satisfaction.key_data = Base64.decode64(test_key)
      satisfaction.key_secret = 'notasecret'
      satisfaction.sheet = '1SK6PQVpmzA2HIbB1Ln1F0cSh8u12bcnutP_vgdQHTHE'
      satisfaction.range = 'Sessions!MonthlyData'
    end
  end

  def when_i_import_google_session_data
    Importers::Google::Sessions::Importer.new.import
  end

  def then_web_transaction_data_has_been_saved
    expect(AppointmentSummary.last).to have_attributes(
      year_month_id: YearMonth.find_by(value: '2016-08').id,
      delivery_partner: Partners::WEB_VISITS,
      transactions: 10_000,
      bookings: 0,
      completions: 0
    )
  end
end
