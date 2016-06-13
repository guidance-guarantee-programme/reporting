class EditAppointmentSummaryPage < SitePrism::Page
  set_url '/appointment_summaries/{id}/edit'

  element :delivery_partner, '.t-delivery_partner'
  element :period_end, '.t-period_end'
  element :transactions, '.t-transactions'
  element :bookings, '.t-bookings'
  element :completions, '.t-completions'

  element :update_button, '.t-update-button'
end
