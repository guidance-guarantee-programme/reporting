require 'rails_helper'
require 'importers'
require 'mail_retriever'

RSpec.feature 'Importing TPAS data' do
  scenario 'Storing satisfaction data' do
    when_i_import_tpas_data
    then_the_satisfaction_data_has_been_saved
  end

  scenario 'Re-importing satisfaction data does not create duplicates' do
    when_i_import_tpas_data
    and_i_import_tpas_data_a_second_time
    then_the_satisfaction_data_has_been_saved
  end

  def when_i_import_tpas_data
    setup_imap_server(
      attachment:  File.read(Rails.root.join('spec/fixtures/tpas.csv'), mode: 'rb')
    )
    Importers::Tpas::Importer.new.import
  end

  def and_i_import_tpas_data_a_second_time
    Importers::Tpas::Importer.new.import
  end

  def setup_imap_server(attachment:)
    mail_attachment = double( # Replace with local IMap server
      :mail_attachment,
      file: StringIO.new(attachment),
      uid: SecureRandom.uuid
    )
    allow_any_instance_of(MailRetriever).to receive(:search).and_return([mail_attachment])
    allow_any_instance_of(MailRetriever).to receive(:archive).and_return(true)
  end

  def then_the_satisfaction_data_has_been_saved # rubocop:disable Metrics/MethodLength
    entries = Satisfaction.order("date_part('hour', given_at)").group("date_part('hour', given_at)").count
    expect(entries).to eq(
      8.0 => 4,
      9.0 => 65,
      10.0 => 219,
      11.0 => 187,
      12.0 => 109,
      13.0 => 139,
      14.0 => 114,
      15.0 => 169,
      16.0 => 167,
      17.0 => 32,
      18.0 => 66
    )
  end
end
