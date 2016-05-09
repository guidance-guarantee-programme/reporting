require 'rails_helper'
require 'importers'
require 'mail_retriever'

RSpec.feature 'Importing twilio call data', vcr: { cassette_name: 'twilio_single_page_of_data' } do
  let(:start_date) { Date.new(2016, 4, 11) }
  let(:end_date) { Date.new(2016, 4, 12) }
  let(:tp_config) { double(:config, tp: { user_name: 'researchuploads@pensionwise.gob.uk', password: '1234' }) }

  before do
    allow(Rails.configuration).to receive(:x).and_return(tp_config)
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

  def given_old_daily_call_volumes_exists
    @daily_call = DailyCallVolume.create!(
      date: Date.new(2016, 5, 4),
      tp: 10
    )
  end

  def when_i_import_tp_data
    setup_imap_server(File.read(Rails.root.join('spec/fixtures/TP-20160505.xlsx'), mode: 'rb'))
    Importers::DailyCalls::TP::Importer.new.import
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
    match_call(
      DailyCallVolume.first,
      date: Date.new(2016, 5, 4), twilio: 0, tp: 371
    )
  end

  def then_the_daily_call_volume_for_tp_should_be_updated
    @daily_call.reload
    expect(@daily_call.tp).to eq(371)
  end

  def match_call(call, values)
    values.each do |field, expected_value|
      expect(call[field]).to eq(expected_value)
    end
  end
end