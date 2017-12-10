require 'rails_helper'
require 'importers'

RSpec.feature 'Importing Tesco satisfaction data', vcr: { cassette_name: 'tesco_satisfaction_data' } do
  scenario 'Successfully importing spreadsheet data' do
    given_the_importer_is_configured
    when_data_is_imported
    then_cita_data_is_persisted
    and_cas_data_is_persisted
  end

  def given_the_importer_is_configured
    dummy_key = IO.read(Rails.root.join('spec/fixtures/reporting-testing-key.txt'))

    Rails.configuration.x.tesco_satisfaction.tap do |satisfaction|
      satisfaction.key_data   = Base64.decode64(dummy_key)
      satisfaction.key_secret = 'notasecret'
    end
  end

  def when_data_is_imported
    Importers::Tesco::Satisfaction::Importer.new.import
  end

  def then_cita_data_is_persisted
    expect(data_for_delivery_centre(:cita)).to eq(
      [
        ['tesco:cita:1', Time.zone.parse('2017-11-13 13:49:53'), 3, 'Tesco Delamare (Hatfield)'],
        ['tesco:cita:2', Time.zone.parse('2017-11-14 11:56:14'), 3, 'Tesco Bank (Longbenton)']
      ]
    )
  end

  def and_cas_data_is_persisted
    expect(data_for_delivery_centre(:cas)).to eq(
      [
        ['tesco:cas:1', Time.zone.parse('2017-11-13 17:27:38'), 3, 'Tesco Bank (Glasgow)'],
        ['tesco:cas:2', Time.zone.parse('2017-11-14 10:32:03'), 4, 'Tesco Bank (EHQ)']
      ]
    )
  end

  def data_for_delivery_centre(dc)
    Satisfaction
      .where(delivery_partner: dc)
      .pluck(:uid, :given_at, :satisfaction, :location)
  end
end
