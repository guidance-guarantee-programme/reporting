Given(/^there are existing satisfaction records$/) do
  create_list(:satisfaction, 2)
end

When(/^I visit the satisfaction report$/) do
  @page = SatisfactionReportPage.new
  @page.load
end

Then(/^I see the satisfaction summary report$/) do
  expect(@page).to have_rows(count: 10)
end

When(/^I export the summary data to CSV$/) do
  @page.export_summary_csv.click
end

When(/^I export the raw data to CSV$/) do
  @page.export_raw_csv.click
end

Then(/^I can filter the report by month$/) do
  expect(@page).to have_month
end

Then(/^I am prompted to download the "([^"]*)" CSV$/) do |filename|
  expect(page.response_headers).to include(
    'Content-Disposition' => "attachment; filename=#{filename}.csv",
    'Content-Type'        => 'text/csv'
  )
end
