require 'rails_helper'
require 'importers'
require 'mail_retriever'

RSpec.feature 'Importing twilio call data', vcr: { cassette_name: 'twilio_single_page_of_data' } do
  let(:start_date) { Date.new(2016, 4, 11) }
  let(:end_date) { Date.new(2016, 4, 12) }
  let(:config) do
    ActiveSupport::OrderedOptions[
      user_name: 'researchuploads@pensionwise.gob.uk',
      password: '1234',
      search_string: 'SUBJECT "TP Daily Call Data"',
      file_name_regexp: /Daily Data File.*\.xlsx/,
      sheet_name: 'Call Details'
    ]
  end

  scenario 'Storing daily call volumes for use in the Minister For Pensions report' do
    when_i_import_tp_data
    then_the_daily_call_volume_for_tp_should_be_saved
  end

  scenario 'Updating daily call volumes' do
    given_old_daily_call_volumes_exists
    when_i_import_tp_data
    then_the_daily_call_volume_for_tp_should_be_updated
  end

  scenario 'Storing where did you hear data' do
    when_i_import_tp_data
    then_the_where_did_you_hear_data_has_been_saved
  end

  def given_old_daily_call_volumes_exists
    @daily_call = DailyCallVolume.create!(
      date: Date.new(2016, 5, 4),
      tp: 10
    )
  end

  def when_i_import_tp_data
    setup_mappings
    setup_imap_server(File.read(Rails.root.join('spec/fixtures/TP-20160505.xlsx'), mode: 'rb'))
    Importers::TP::Importer.new(config: config).import
  end

  def setup_mappings
    create(:code_lookup, from: 'WDYH_RA', to: 'Advertising')
    create(:code_lookup, from: 'WDYH_PP', to: 'Pension Provider')

    create(:code_lookup, from: 'PP_PHOENIXLIFE', to: 'Phoenix Life')
    create(:code_lookup, from: 'PP_SCOTWID', to: 'Scottish Widows')
  end

  def setup_imap_server(attachment)
    mail_attachment = double( # Replace with local IMAp server
      :mail_attachment,
      file: StringIO.new(attachment),
      uid: SecureRandom.uuid
    )
    allow_any_instance_of(MailRetriever).to receive(:search).and_return([mail_attachment])
    allow_any_instance_of(MailRetriever).to receive(:archive).and_return(true)
  end

  def then_the_daily_call_volume_for_tp_should_be_saved
    expect(DailyCallVolume.count).to eq(1)
    expect(DailyCallVolume.first).to have_attributes(
      date: Date.new(2016, 5, 4),
      twilio: 0,
      tp: 3
    )
  end

  def then_the_daily_call_volume_for_tp_should_be_updated
    @daily_call.reload
    expect(@daily_call.tp).to eq(3)
  end

  def then_the_where_did_you_hear_data_has_been_saved
    entry = WhereDidYouHear.last
    expect(entry.given_at).to eq('2016-05-04 08:36:17 UTC')

    expect(entry).to have_attributes(
      heard_from: 'Pension Provider',
      pension_provider: 'Scottish Widows',
      location: '',
      delivery_partner: 'TP'
    )
  end
end
