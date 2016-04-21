class CallVolumesReportPage < SitePrism::Page
  set_url '/reports/call_volumes{?query*}'

  element :start_date, '.t-start-date'
  element :end_date, '.t-end-date'
  element :filter_button, '.t-filter-button'

  element :total_twilio_calls, '.t-total-twilio-calls'
  sections :days, '.t-call-day' do
    element :date, '.t-call-date'
    element :twilio_calls, '.t-twilio-calls'
  end
end
