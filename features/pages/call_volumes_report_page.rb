class CallVolumesReportPage < SitePrism::Page
  set_url '/reports/call_volumes{?query*}'

  element :start_date, '.t-start-date'
  element :end_date, '.t-end-date'
  element :search, '.t-search'
  element :export_csv, '.t-export-csv'

  element :total_twilio_calls, '.t-total-twilio-calls'
  element :total_tp_calls, '.t-total-tp-calls'

  sections :days, '.t-call-day' do
    element :date, '.t-call-date'
    element :twilio_calls, '.t-twilio-calls'
    element :tp_calls, '.t-tp-calls'
  end
end
