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
    responses = Satisfaction.order(:given_at).pluck(:uid, :satisfaction, :sms_response, :delivery_partner, :location)

    expect(responses).to match_array(
      [
        ['b018c71a75b989ae8f3141329521bc99', 4, 1, 'cita_telephone', 'staffordshire_sw'],
        ['a63eda8dba7f36c7bf855da019ad439d', 4, 3, 'cita_telephone', 'staffordshire_sw'],
        ['0c24adb62505a524edd89ce2d1f912a0', 4, 1, 'cita_telephone', 'staffordshire_sw'],
        ['2bbaf43ac86cb66582735fd15d5bc255', 4, 2, 'cita_telephone', 'staffordshire_sw'],
        ['0b898d4d0a0982a207daadb4078ff91f', 4, 1, 'cita_telephone', 'staffordshire_sw'],
        ['49e5d0042c2ef6657161a965003859a8', 3, 1, 'cita_telephone', 'staffordshire_sw']
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
      subject: 'Staffordshire SW Telephony Exit Poll data wc01.03',
      file: StringIO.new(attachment),
      uid: SecureRandom.uuid
    )
    mail_retriever = instance_double(MailRetriever, search: [mail_attachment], archive: true)
    allow(MailRetriever).to receive(:new).and_return(mail_retriever)
  end
end
