require 'rails_helper'
require 'importers'

# rubocop:disable Metrics/BlockLength
RSpec.feature 'Importing Tesco satisfaction data', vcr: { cassette_name: 'tesco_satisfaction_data' } do
  scenario 'Successfully importing spreadsheet data' do
    skip 'Temporarily skip'
    given_the_importer_is_configured
    when_data_is_imported
    then_cita_data_is_persisted
    and_cas_data_is_persisted
    and_the_nicab_data_is_persisted
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
        ['tesco:cita:1:1523264400', Time.zone.parse('2018-04-09 09:00'), 0, 'Chester'],
        ['tesco:cita:2:1523264400', Time.zone.parse('2018-04-09 09:00'), 4, 'Derby Mickleover']
      ]
    )
  end

  def and_cas_data_is_persisted
    expect(data_for_delivery_centre(:cas)).to eq(
      [
        ['tesco:cas:1:1523350800', Time.zone.parse('2018-04-10 09:00'), 4, 'Annan'],
        ['tesco:cas:2:1523350800', Time.zone.parse('2018-04-10 09:00'), 2, 'Annan']
      ]
    )
  end

  def and_the_nicab_data_is_persisted
    expect(data_for_delivery_centre(:nicab)).to eq(
      [
        ['tesco:nicab:1:1523523600', Time.zone.parse('2018-04-12 09:00'), 0, 'Coleraine'],
        ['tesco:nicab:2:1524560400', Time.zone.parse('2018-04-24 09:00'), 4, 'Antrim Massereene Extra']
      ]
    )
  end

  def data_for_delivery_centre(delivery_centre)
    Satisfaction
      .where(delivery_partner: delivery_centre)
      .pluck(:uid, :given_at, :satisfaction, :location)
  end
end
# rubocop:enable Metrics/BlockLength
