Given(/^an existing automatically generated appointment summary record exists$/) do
  @transaction = create(
    :appointment_summary,
    year_month: YearMonth.current,
    transactions: 200,
    bookings: 150,
    completions: 25
  )
end

When(/^I create a new appointment summary record$/) do
  YearMonth.current

  @page = NewAppointmentSummaryPage.new
  @page.load

  @page.delivery_partner.select(Partners::TPAS)
  @page.year_month.set(Time.zone.today.strftime('%b %Y'))
  @page.transactions.set(100)
  @page.bookings.set(80)
  @page.completions.set(60)

  @page.create_button.click
end

When(/^I attempt to create a new appointment summary record$/) do
  @page = NewAppointmentSummaryPage.new
  @page.load
end

When(/^I edit the appointment summary record$/) do
  @page = EditAppointmentSummaryPage.new
  @page.load(id: @transaction.id)

  @page.delivery_partner.select(Partners::TPAS)
  @page.year_month.set(Time.zone.today.strftime('%b %Y'))
  @page.transactions.set(100)
  @page.bookings.set(80)
  @page.completions.set(60)

  @page.update_button.click
end

Then(/^I am redirected away with the notice "([^"]*)"$/) do |_notice|
  expect(@page).not_to be_displayed
end

Then(/^the appointment summary record is successfully saved$/) do
  expect(AppointmentSummary.last).to have_attributes(
    delivery_partner: Partners::TPAS,
    year_month_id: YearMonth.current.id,
    transactions: 100,
    bookings: 80,
    completions: 60,
    source: 'manual'
  )
end

Then(/^my changes are saved and the record is marked as a manually generated appointment summary record$/) do
  @transaction.reload
  expect(@transaction).to have_attributes(
    delivery_partner: Partners::TPAS,
    year_month_id: YearMonth.current.id,
    transactions: 100,
    bookings: 80,
    completions: 60,
    source: 'manual'
  )
end

When(/^I upload the (.*) file for processing$/) do |filename|
  @page = CitaAppointmentsUploadPage.new
  @page.load

  @page.upload(Rails.root.join('features', 'fixtures', filename))
end

Then(/^I can see the data file scheduled for processing$/) do
  expect(@page).to have_scheduled

  expect(ActiveJob::Base.queue_adapter.enqueued_jobs.last).to include(
    job: ImportCitaData,
    args: ::ActiveJob::Arguments.serialize([UploadedFile.last]),
    queue: 'default'
  )
end

Then(/^I get an error$/) do
  expect(@page).to have_errors
end

Then(/^the data file is not scheduled for processing$/) do
  expect(@page).not_to have_scheduled
end

When(/^I attempt to upload the CITA appointments CSV$/) do
  @page = CitaAppointmentsUploadPage.new
  @page.load
end
