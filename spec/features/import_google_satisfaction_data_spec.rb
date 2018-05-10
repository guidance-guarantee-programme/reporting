require 'rails_helper'
require 'importers'

RSpec.feature 'Importing satisfaction data', vcr: { cassette_name: 'google_satisfaction_data' } do
  let(:test_user) { 'reporting-testing@pension-wise.iam.gserviceaccount.com' }
  let(:test_key) { File.read(Rails.root.join('spec/fixtures/reporting-testing-key.txt')) }

  scenario 'from google forms' do
    given_i_have_a_configured_google_account
    when_i_import_google_satisfaction_data
    then_google_satisfaction_data_has_been_saved_for_cas
    then_google_satisfaction_data_has_been_saved_for_cita
    then_google_satisfaction_data_has_been_saved_for_nicab
  end

  def given_i_have_a_configured_google_account
    Rails.configuration.x.google_satisfaction.tap do |satisfaction|
      satisfaction.service_account_email = test_user
      satisfaction.key_data = Base64.decode64(test_key)
      satisfaction.key_secret = 'notasecret'
      satisfaction.sheets = sheets
      satisfaction.range = 'A:K'
    end
  end

  def sheets
    {
      nicab: '1EJCoyQc2Zq4ntSlfqKFnSu65J67MxJJ8hN28YIZ9vWk',
      cas: '1lF76h4ICYW3MyLIAslstfqhnebs9ciZjx5pcw6nRaGQ',
      cita: '15NV6AIlQMW_5iV0i4F279Hxwk2_Mj8OHllTLHJXTdV4'
    }
  end

  def when_i_import_google_satisfaction_data
    Importers::Google::Satisfaction::Importer.new.import
  end

  def then_google_satisfaction_data_has_been_saved_for_cas
    expect(Satisfaction.where(delivery_partner: 'cas').pluck(:uid, :given_at, :satisfaction, :location)).to eq(
      [
        ['cas:1:1464166800', Time.zone.parse('2016-05-25 09:00'), 2, 'Citizens Advice Edinburgh (Administration)'],
        ['cas:2:1464253200', Time.zone.parse('2016-05-26 09:00'), 4, 'Aberdeen Citizens Advice Bureau']
      ]
    )
  end

  def then_google_satisfaction_data_has_been_saved_for_cita
    expect(Satisfaction.where(delivery_partner: 'cita').pluck(:uid, :given_at, :satisfaction, :location)).to eq(
      [
        ['cita:1:1464166800', Time.zone.parse('2016-05-25 09:00'), 0, 'Lincoln & District'],
        ['cita:2:1464166800', Time.zone.parse('2016-05-25 09:00'), 4, 'Peterborough']
      ]
    )
  end

  def then_google_satisfaction_data_has_been_saved_for_nicab
    expect(Satisfaction.where(delivery_partner: 'nicab').pluck(:uid, :given_at, :satisfaction, :location)).to eq(
      [
        ['nicab:1:1464166800', Time.zone.parse('2016-05-25 09:00'), 4, 'Newtownabbey'],
        ['nicab:2:1464080400', Time.zone.parse('2016-05-24 09:00'), 3, 'Banbridge']
      ]
    )
  end
end
