class NewAppointmentSummaryPage < SitePrism::Page
  set_url '/appointment_summaries/new'

  element :delivery_partner, '.t-delivery_partner'
  element :period_end, '.t-period_end'
  element :transactions, '.t-transactions'
  element :bookings, '.t-bookings'
  element :completions, '.t-completions'

  element :create_button, '.t-create-button'
end
