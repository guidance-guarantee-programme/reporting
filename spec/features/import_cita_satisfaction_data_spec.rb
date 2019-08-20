require 'rails_helper'
require 'importers'
require 'mail_retriever'

RSpec.feature 'Importing CITA telephony data' do
  scenario 'Storing satisfaction data' do
    when_i_import_cita_data
    then_the_satisfaction_data_has_been_saved
    when_the_same_data_is_imported
    then_no_duplicates_are_created
  end

  def when_i_import_cita_data
    setup_imap_server(
      attachment: File.read(Rails.root.join('spec/fixtures/cita_satisfaction.csv'), mode: 'rb')
    )
    Importers::CitaSatisfaction::Importer.new.import
  end

  def then_the_satisfaction_data_has_been_saved # rubocop:disable MethodLength
    responses = Satisfaction.order(:given_at).pluck(:uid, :satisfaction, :sms_response)

    expect(responses).to match_array(
      [
        ['cita_telephone:6.02179E+22', 3, 1],
        ['cita_telephone:6.02589E+22', 4, 1],
        ['cita_telephone:6.03227E+22', 4, 1],
        ['cita_telephone:6.12621E+22', 4, 3],
        ['cita_telephone:6.13837E+22', 4, 2],
        ['cita_telephone:6.02817E+22', 4, 1]
      ]
    )
  end

  def when_the_same_data_is_imported
    Importers::CitaSatisfaction::Importer.new.import
  end

  def then_no_duplicates_are_created
    expect(Satisfaction.count).to eq(6)
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
end
