require 'rails_helper'
require 'importers'
require 'mail_retriever'

RSpec.feature 'Importing PWNI telephony data' do
  scenario 'Storing satisfaction data' do
    when_i_import_pwni_data
    then_the_satisfaction_data_has_been_saved
    when_the_same_data_is_imported
    then_no_duplicates_are_created
  end

  def when_i_import_pwni_data
    setup_imap_server(
      attachment: File.read(Rails.root.join('spec/fixtures/pwni_satisfaction.csv'), mode: 'rb')
    )
    Importers::PwniSatisfaction::Importer.new.import
  end

  def then_the_satisfaction_data_has_been_saved
    responses = Satisfaction.order(:given_at).pluck(:uid, :satisfaction, :sms_response)

    expect(responses).to match_array(
      [
        ['pwni_telephone:6.01322E+22', 4, 1],
        ['pwni_telephone:6.11189E+22', 2, 3],
        ['pwni_telephone:6.11763E+22', 0, 1]
      ]
    )
  end

  def when_the_same_data_is_imported
    Importers::PwniSatisfaction::Importer.new.import
  end

  def then_no_duplicates_are_created
    expect(Satisfaction.count).to eq(3)
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
