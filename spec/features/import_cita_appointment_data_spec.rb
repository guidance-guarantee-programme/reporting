require 'rails_helper'
require 'importers'

RSpec.feature 'Importing CITA appointment data' do
  let(:cita_appointments) do
    create(:uploaded_file, data: File.read(Rails.root.join('spec', 'fixtures', 'cita_appointments.csv')))
  end

  scenario 'Processing CITA appointments UploadedFile' do
    when_i_process_the_uplaoded_file(cita_appointments)
    then_transaction_data_is_saved
    and_summarised_month_to_date_is_saved
  end

  def when_i_process_the_uplaoded_file(uploaded_file)
    Importers::Cita::Importer.new.import(uploaded_file)
  end

  def then_transaction_data_is_saved
    expect(Appointment.count).to eq(1)
    expect(Appointment.find_by(uid: '42410.629861111142410.6298611111Sanchez, Rick')).to have_attributes(
      booked_at: Time.zone.parse('Wed, 10 Feb 2016 15:06:59 UTC +00:00'),
      booking_at: Time.zone.parse('Fri, 01 Apr 2016 00:00:00 UTC +00:00'),
      cancelled: false,
      booking_status: 'Booked',
      delivery_partner: 'cita',
      version: 1,
      created_at: Time.zone.parse('Wed, 10 Feb 2016 15:06:59 UTC +00:00')
    )
  end

  def and_summarised_month_to_date_is_saved
    expect(summary).to eq(
      [
        [0, 1, 0, 'cita', '2016-02', 'automatic']
      ]
    )
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
