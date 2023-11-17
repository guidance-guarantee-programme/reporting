require 'rails_helper'
require 'importers'
require 'mail_retriever'

# rubocop:disable Metrics/BlockLength
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
        ['6dceb5a12d986eeebb289fd9105da4f8', 4, 1],
        ['4f6d7ae208e6b04dd835e7329d5c8aba', 2, 3],
        ['35f585dcce477c3276adca46409bfe2d', 0, 1]
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
# rubocop:enable Metrics/BlockLength
