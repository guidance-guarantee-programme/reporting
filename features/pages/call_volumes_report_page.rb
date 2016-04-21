class CallVolumesReportPage < SitePrism::Page
  set_url '/reports/call_volumes{?query*}'

  section :calls, '.t-calls' do
    sections :days, '.t-call-day' do
      element :date, '.t-call-date'
      element :twilio_volume, '.t-call-twilio'
    end
  end
end
