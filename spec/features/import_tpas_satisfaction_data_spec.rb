require 'rails_helper'
require 'importers'
require 'mail_retriever'

# rubocop:disable Metrics/BlockLength
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

  scenario 'Correctly maps the option value to satisfaction score' do
    when_i_import_tpas_data
    then_the_satisfaction_mappings_are_correct
  end

  def when_i_import_tpas_data
    setup_imap_server(
      attachment: File.read(Rails.root.join('spec/fixtures/tpas_satisfaction.csv'), mode: 'rb')
    )
    Importers::TpasSatisfaction::Importer.new.import
  end

  def and_i_import_tpas_data_a_second_time
    Importers::TpasSatisfaction::Importer.new.import
  end

  def setup_imap_server(attachment:)
    mail_attachment = double( # Replace with local IMap server
      :mail_attachment,
      file: StringIO.new(attachment),
      uid: SecureRandom.uuid
    )
    mail_retriever = instance_double(MailRetriever, search: [mail_attachment], archive: true)
    allow(MailRetriever).to receive(:new).and_return(mail_retriever)
  end

  def then_the_satisfaction_data_has_been_saved # rubocop:disable Metrics/MethodLength
    entries = Satisfaction
              .order(Arel.sql("date_part('hour', given_at)"))
              .group(Arel.sql("date_part('hour', given_at)"))
              .count

    expect(entries).to eq(
      9.0 => 5,
      10.0 => 5,
      11.0 => 6,
      12.0 => 2,
      13.0 => 7,
      14.0 => 5,
      15.0 => 5,
      16.0 => 3,
      17.0 => 2,
      18.0 => 1
    )
  end

  def then_the_satisfaction_mappings_are_correct
    entries = Satisfaction.order(:satisfaction).group(:satisfaction).count
    expect(entries).to eq(
      2 => 2,
      3 => 8,
      4 => 31
    )
  end
end
# rubocop:enable Metrics/BlockLength
