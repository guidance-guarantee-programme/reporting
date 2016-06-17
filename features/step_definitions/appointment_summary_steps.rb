Given(/^an existing automatically generated appointment summary record exists$/) do
  @transaction = create(
    :appointment_summary,
    reporting_month: '2016-05',
    transactions: 200,
    bookings: 150,
    completions: 25
  )
end

When(/^I create a new appointment summary record$/) do
  @page = NewAppointmentSummaryPage.new
  @page.load

  @page.delivery_partner.select(Partners::TPAS)
  @page.reporting_month.set('05-2016')
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
  @page.reporting_month.set('05-2016')
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
    reporting_month: '05-2016',
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
    reporting_month: '05-2016',
    transactions: 100,
    bookings: 80,
    completions: 60,
    source: 'manual'
  )
end
