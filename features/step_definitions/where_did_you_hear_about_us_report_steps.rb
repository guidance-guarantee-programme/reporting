Given(/^there are existing where did you hear about us records$/) do
  create_list(:where_did_you_hear, Kaminari.config.default_per_page + 1)
end

When(/^I visit the where did you hear about us report$/) do
  @page = WhereDidYouHearAboutUsReportPage.new
  @page.load
end

Then(/^I am presented with where did you hear about us records$/) do
  expect(@page).to have_rows(count: Kaminari.config.default_per_page)
end

Then(/^I see there are multiple pages$/) do
  expect(@page).to have_pages
end

Then(/^the date range is displayed$/) do
  expect(@page.start_date.value).to be_present
  expect(@page.end_date.value).to be_present
end

Then(/^I am prompted to download the CSV$/) do
  expect(page.response_headers).to include(
    'Content-Disposition' => 'attachment; filename=where_did_you_hear.csv',
    'Content-Type'        => 'text/csv'
  )
end

When(/^I request the summary report$/) do
  @page.summary_report.click
end

Then(/^I see the summary report$/) do
  expect(@page).to have_rows
end
