require 'rails_helper'
require 'importers'
require 'mail_retriever'

RSpec.feature 'Importing CAS data' do
  scenario 'Storing satisfaction data' do
    when_i_import_cas_data
    then_the_satisfaction_data_has_been_saved
  end

  scenario 'Re-importing satisfaction data does not create duplicates' do
    when_i_import_cas_data
    and_i_import_cas_data_a_second_time
    then_the_satisfaction_data_has_been_saved
  end

  def when_i_import_cas_data
    setup_imap_server(
      attachment: File.read(
        Rails.root.join('spec', 'fixtures', 'KM CAS Tele Exit Poll (ongoing) 2018_1709.csv'),
        mode: 'rb'
      )
    )

    Importers::CasSatisfaction::Importer.new.import
  end
  alias_method :and_i_import_cas_data_a_second_time, :when_i_import_cas_data

  def setup_imap_server(attachment:)
    mail_attachment = double(
      :mail_attachment,
      file: StringIO.new(attachment),
      uid: SecureRandom.uuid
    )

    mail_retriever = instance_double(MailRetriever, search: [mail_attachment], archive: true)
    allow(MailRetriever).to receive(:new).and_return(mail_retriever)
  end

  def then_the_satisfaction_data_has_been_saved
    expect(Satisfaction.pluck(:uid, :satisfaction, :sms_response)).to contain_exactly(
      ['CAS000001', 4, 1],
      ['CAS000002', 4, 1],
      ['CAS000003', 3, 3],
      ['CAS000004', 4, 1],
      ['CAS000012', 4, 3],
      ['CAS000013', 0, 0],
      ['CAS000135', 3, 0]
    )
  end
end
