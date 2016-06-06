require 'rails_helper'
require 'importers'
require 'mail_retriever'

RSpec.feature 'Importing smart survey data' do
  scenario 'Storing NICAB where did you hear data' do
    when_i_import_smart_survey_data(partner: 'NICAB')
    then_the_where_did_you_hear_data_has_been_saved(partner: 'NICAB')
  end

  scenario 'Storing CITA where did you hear data' do
    when_i_import_smart_survey_data(partner: 'CITA')
    then_the_where_did_you_hear_data_has_been_saved(partner: 'CITA')
  end

  scenario 'Storing CAS where did you hear data' do
    when_i_import_smart_survey_data(partner: 'CAS')
    then_the_where_did_you_hear_data_has_been_saved(partner: 'CAS')
  end

  def when_i_import_smart_survey_data(partner:)
    setup_mappings
    setup_imap_server(
      attachment: File.read(Rails.root.join('spec/fixtures/smart_survey.csv'), mode: 'rb'),
      partner: partner
    )
    Importers::SmartSurvey::Importer.new.import
  end

  def setup_mappings
    create(:code_lookup, from: 'WDYH_WOM', to: 'Word of Mouth')
  end

  def setup_imap_server(attachment:, partner:)
    mail_attachment = double( # Replace with local IMAp server
      :mail_attachment,
      file: StringIO.new(attachment),
      uid: SecureRandom.uuid,
      body_text: "Hi\n*Report Name:* #{partner} CSV Export"
    )
    mail_retriever = instance_double(MailRetriever, search: [mail_attachment], archive: true)
    allow(MailRetriever).to receive(:new).and_return(mail_retriever)
  end

  def then_the_where_did_you_hear_data_has_been_saved(partner:)
    entry = WhereDidYouHear.last
    expect(entry.given_at).to eq('2016-05-03 09:20:00')

    expect(entry).to have_attributes(
      heard_from: 'Word of Mouth',
      heard_from_raw: 'Friend/Word of mouth',
      pension_provider: 'L&G',
      location: 'Belfast',
      delivery_partner: partner.downcase
    )
  end
end
