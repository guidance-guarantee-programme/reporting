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
