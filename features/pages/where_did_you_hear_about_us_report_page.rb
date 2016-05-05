class WhereDidYouHearAboutUsReportPage < SitePrism::Page
  set_url '/reports/where_did_you_hear{?query*}'

  elements :rows, '.t-row'
  elements :pages, 'li.page'

  element :start_date, '.t-start'
  element :end_date, '.t-end'
  element :export_csv, '.t-export'
end
