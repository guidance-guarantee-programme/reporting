class NewAppointmentSummaryPage < SitePrism::Page
  set_url '/appointment_summaries/new'

  element :delivery_partner, '.t-delivery-partner'
  element :reporting_month, '.t-reporting-month'
  element :transactions, '.t-transactions'
  element :bookings, '.t-bookings'
  element :completions, '.t-completions'

  element :create_button, '.t-create-button'
end
