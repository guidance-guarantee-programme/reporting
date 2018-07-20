require 'rails_helper'
require 'importers'
require 'mail_retriever'

RSpec.feature 'Importing TP data' do
  scenario 'Storing satisfaction data' do
    when_i_import_tp_data
    then_the_satisfaction_data_has_been_saved
  end

  scenario 'Re-importing satisfaction data does not create duplicates' do
    when_i_import_tp_data
    and_i_import_tp_data_a_second_time
    then_the_satisfaction_data_has_been_saved
  end

  def when_i_import_tp_data
    setup_imap_server(
      attachment: File.read(
        Rails.root.join('spec', 'fixtures', 'TP Exit Poll Detail 10072018.xlsx'),
        mode: 'rb'
      )
    )

    Importers::TpSatisfaction::Importer.new.import
  end
  alias_method :and_i_import_tp_data_a_second_time, :when_i_import_tp_data

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
    expect(Satisfaction.pluck(:satisfaction, :sms_response)).to contain_exactly(
      [4, 2],
      [4, 3],
      [4, 1],
      [2, 1],
      [4, 1],
      [4, 1]
    )
  end
end
