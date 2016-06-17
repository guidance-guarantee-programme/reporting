require 'rails_helper'
require 'importers'

RSpec.feature 'Importing booking bug data', vcr: { cassette_name: 'booking_bug_data' } do
  let(:config) do
    double(:config,
           domain: 'booking.pensionwise.gov.uk',
           company_id: 'treasuryw2693708',
           api_key: 'BOOKING_BUG_APP_KEY',
           app_id: '5a3d8b8d',
           email: 'data@pensionwise.gov.uk',
           password: 'BOOKING_BUG_PASSWORD',
           page_size: 100,
           import_all: false
          )
  end
  let(:cancelled_record) do
    {
      'id' => '11111',
      'datetime' => 1.month.from_now,
      'updated_at' => Time.zone.now,
      'created_at' => 1.week.ago,
      'is_cancelled' => true
    }
  end
  let(:booked_record) do
    {
      'id' => '222222',
      'datetime' => 1.month.from_now,
      'updated_at' => Time.zone.now,
      'created_at' => 1.week.ago,
      'is_cancelled' => false
    }
  end

  scenario 'Storing booking bug data for use in the Minister For Pensions report' do
    travel_to('2016-06-14 12:00:00') do
      when_i_import_booking_bug_data
      then_transaction_data_is_saved
      and_summarised_month_to_date_is_saved
    end
  end

  scenario 'Updating booking bug data - summary data with a source of manual is not updated' do
    travel_to('2016-06-14 12:00:00') do
      given_old_booking_bug_data_exists
      when_i_import_booking_bug_data
      then_transaction_data_is_updated_and_versioned_data_is_created
      and_summarised_month_to_date_is_updated
    end
  end

  scenario 'Summary data is only updated when new booking bug records for that month are detected' do
    travel_to('2016-06-14 12:00:00') do
      given_all_data_for_may_2016_exists
      when_i_import_booking_bug_data
      then_only_summary_data_for_jun_2016_is_updated
    end
  end

  scenario 'Cancelling a booking will modify the transaction date be set to the cancellation date' do
    given_a_booking_exists_for_next_month
    when_i_import_booking_bug_data_that_cancels_the_booking
    then_the_booking_has_a_transaction_date_of_today
    and_the_booking_is_counted_as_a_transaction_for_the_current_month
  end

  def given_old_booking_bug_data_exists
    create(:appointment, uid: '35943', booking_status: 'Incomplete')
    create(:appointment_summary, transactions: 6, bookings: 5, completions: 4, reporting_month: '2016-06')
    create(
      :appointment_summary,
      transactions: 3,
      bookings: 2,
      completions: 1,
      reporting_month: '2016-05',
      source: 'manual'
    )
  end

  def given_all_data_for_may_2016_exists
    %w(35943 35911 35929 35988).each { |uid| create(:appointment, uid: uid) }
    create(:appointment_summary, transactions: 3, bookings: 2, completions: 1, reporting_month: '2016-05')
  end

  def given_a_booking_exists_for_next_month
    @transaction = create(:appointment, uid: '11111', booking_at: 1.month.from_now, transaction_at: 1.month.from_now)
  end

  def when_i_import_booking_bug_data
    Importers::BookingBug::Importer.new(config: config).import
  end

  def when_i_import_booking_bug_data_that_cancels_the_booking
    retriever = instance_double(Importers::BookingBug::Retriever)
    allow(retriever).to receive(:process_records)
      .and_yield(cancelled_record)
      .and_yield(booked_record) # needed to trigger summary recalc

    retriever_klass = double(:retriever_klass, new: retriever)

    Importers::BookingBug::Importer.new(retriever: retriever_klass).import
  end

  def then_transaction_data_is_saved
    expect(Appointment.count).to eq(59)
    expect(Appointment.find_by(uid: '35943')).to have_attributes(
      booked_at: Time.zone.parse('Tue, 31 May 2016 10:58:49 UTC +00:00'),
      booking_at: Time.zone.parse('Tue, 14 Jun 2016 07:30:00 UTC +00:00'),
      cancelled: false,
      booking_status: 'Awaiting Status',
      delivery_partner: 'tpas',
      version: 1,
      created_at: Time.zone.parse('Tue, 13 Jun 2016 08:02:05 UTC +00:00')
    )
  end

  def and_summarised_month_to_date_is_saved
    expect(summary).to eq(
      [
        [0, 3, 0, 'tpas', '2016-05', 'automatic'],
        [59, 54, 3, 'tpas', '2016-06', 'automatic']
      ]
    )
  end

  def then_transaction_data_is_updated_and_versioned_data_is_created
    expect(AppointmentVersion.where(uid: '35943').count).to eq(2)
    expect(Appointment.find_by(uid: '35943')).to have_attributes(
      uid: '35943',
      cancelled: false,
      booking_status: 'Awaiting Status',
      delivery_partner: 'tpas',
      version: 2
    )
  end

  def and_summarised_month_to_date_is_updated
    expect(summary).to eq(
      [
        [3, 2, 1, 'tpas', '2016-05', 'manual'],
        [59, 54, 3, 'tpas', '2016-06', 'automatic']
      ]
    )
  end

  def then_only_summary_data_for_jun_2016_is_updated
    expect(summary).to eq(
      [
        [3, 2, 1, 'tpas', '2016-05', 'automatic'],
        [59, 54, 3, 'tpas', '2016-06', 'automatic']
      ]
    )
  end

  def then_the_booking_has_a_transaction_date_of_today
    @transaction.reload
    expect(@transaction.transaction_at.to_date).to eq(Time.zone.today)
  end

  def and_the_booking_is_counted_as_a_transaction_for_the_current_month
    expect(summary).to eq([[1, 1, 0, 'tpas', Time.zone.today.strftime('%Y-%m'), 'automatic']])
  end

  def summary
    AppointmentSummary.pluck(
      :transactions,
      :bookings,
      :completions,
      :delivery_partner,
      :reporting_month,
      :source
    )
  end
end
