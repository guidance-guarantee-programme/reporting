class SatisfactionReportPage < SitePrism::Page
  set_url '/reports/satisfaction_summary{?query*}'

  elements :rows, '.t-row'

  element :start_date, '.t-start'
  element :end_date, '.t-end'
end
