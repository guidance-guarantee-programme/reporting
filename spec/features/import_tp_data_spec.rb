require 'rails_helper'
require 'importers'
require 'mail_retriever'

RSpec.feature 'Importing tp data' do
  scenario 'Storing daily call volumes for use in the Minister For Pensions report' do
    when_i_import_tp_data
    then_the_daily_call_volume_for_tp_should_be_saved
  end

  scenario 'Storing tp call record' do
    when_i_import_tp_data
    then_the_call_records_for_tp_should_be_saved
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

  scenario 'Correctly format number fields' do
    when_i_import_tp_data_for_27_april
    then_number_fields_are_correctly_parsed
    and_correctly_calculates_call_volumes
    and_correctly_calculates_where_did_you_hear_volumes
  end

  def given_old_daily_call_volumes_exists
    @daily_call = DailyCallVolume.create!(
      date: Date.new(2016, 5, 4),
      contact_centre: 10
    )
  end

  def when_i_import_tp_data
    setup_mappings
    setup_imap_server(File.read(Rails.root.join('spec/fixtures/TP-20160505.xlsx'), mode: 'rb'))
    Importers::TP::Importer.new.import
  end

  def when_i_import_tp_data_for_27_april
    setup_full_mappings
    setup_imap_server(File.read(Rails.root.join('spec/fixtures/TP-20160428-full.xlsx'), mode: 'rb'))
    Importers::TP::Importer.new.import
  end

  def setup_full_mappings
    allow(ENV).to receive(:key?).with('RESET_CODE_LOOKUPS').and_return(true)
    load Rails.root.join('db/seeds/code_lookups.rb')
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
    mail_retriever = instance_double(MailRetriever, search: [mail_attachment], archive: true)
    allow(MailRetriever).to receive(:new).and_return(mail_retriever)
  end

  def then_the_daily_call_volume_for_tp_should_be_saved
    expect(DailyCallVolume.count).to eq(1)
    expect(DailyCallVolume.first).to have_attributes(
      date: Date.new(2016, 5, 4),
      twilio: 0,
      contact_centre: 3
    )
  end

  def then_the_call_records_for_tp_should_be_saved
    expect(TpCall.first).to have_attributes(
      uid: '0332b7444d0608369a7af36e5a7996d0',
      called_at: Time.zone.parse('2016-05-04 08:25:49'),
      outcome: 'Customer Not Eligible - Pension Type',
      third_party_referring: '',
      pension_provider: '',
      call_duration: 143,
      location: ''
    )
  end

  def then_the_daily_call_volume_for_tp_should_be_updated
    @daily_call.reload
    expect(@daily_call.contact_centre).to eq(3)
  end

  def then_the_where_did_you_hear_data_has_been_saved
    entry = WhereDidYouHear.last
    expect(entry.given_at).to eq('2016-05-04 08:36:17 UTC')

    expect(entry).to have_attributes(
      heard_from: 'Pension Provider',
      pension_provider: 'Scottish Widows',
      location: '',
      delivery_partner: 'contact_centre'
    )
  end

  def then_number_fields_are_correctly_parsed
    entry = WhereDidYouHear.find_by!(given_at: Time.zone.parse('27 Apr 2016 19:27:47 UTC +00:00'))
    expect(entry.raw_uid[7]).to eq('0.5')
  end

  def and_correctly_calculates_call_volumes
    expect(DailyCallVolume.first.contact_centre).to eq(391) # 392 records - 1 TestCode
  end

  def and_correctly_calculates_where_did_you_hear_volumes
    expect(WhereDidYouHear.group('raw_uid->>8').count).to eq(
      'Refer to 3rd Party' => 208,
      'Refer to Pension Wise website' => 3,
      'Customer Not Eligible - Pension Type' => 4,
      'TPAS BAU Handoff' => 13,
      'TPAS Appointment Booked' => 59,
      'Customer Not Eligible - Age' => 5
    )
  end
end
