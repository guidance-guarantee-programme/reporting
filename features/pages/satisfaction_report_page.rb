class SatisfactionReportPage < SitePrism::Page
  set_url '/reports/satisfaction_summary{?query*}'

  elements :rows, '.t-row'

  element :month, '.t-month'

  element :export_summary_csv, '.t-export-csv'
  element :export_raw_csv, '.t-export-raw-csv'
end
