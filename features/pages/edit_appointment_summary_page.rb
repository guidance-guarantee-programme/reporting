class EditAppointmentSummaryPage < SitePrism::Page
  set_url '/appointment_summaries/{id}/edit'

  element :delivery_partner, '.t-delivery-partner'
  element :reporting_month, '.t-reporting-month'
  element :transactions, '.t-transactions'
  element :bookings, '.t-bookings'
  element :completions, '.t-completions'

  element :update_button, '.t-update-button'
end
