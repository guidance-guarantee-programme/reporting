Given(/^I am logged in as a Pension Wise data analyst$/) do
  User.create!(
    name: 'Data analyst',
    email: 'analyst@pensionwise.gov.uk',
    uid: SecureRandom.uuid,
    permissions: ['signin'],
    remotely_signed_out: false,
    disabled: false
  )
end

Given(/^there are existing daily call volumes for (Twilio|TP)$/) do |source|
  @call_volumes = {}

  @start_date = 7.days.ago.to_date
  @end_date = 1.day.ago.to_date

  (@start_date..@end_date).each do |date|
    DailyCallVolume.create!(
      date: date,
      source.downcase => @call_volumes[date.to_s(:govuk_date)] = rand(100)
    )
  end
end

When(/^I visit the call volume report$/) do
  @page = CallVolumesReportPage.new
  @page.load
end

When(/^I enter a valid date range$/) do
  @start_date ||= 7.days.ago.to_date
  @end_date ||= 1.day.ago.to_date

  @page.start_date.set(@start_date)
  @page.end_date.set(@end_date)
  @page.search.click
end

Then(/^the total number of calls for (Twilio|TP) within the date range is returned$/) do |source|
  expect(@page.send("total_#{source.downcase}_calls").text.to_i).to eq(@call_volumes.values.sum)
end

Then(/^a day-by-by breakdown for (Twilio|TP) within the date range is returned$/) do |source|
  call_volumes = @page.days.map { |day| [day.date.text, day.send("#{source.downcase}_calls").text.to_i] }
  expect(call_volumes).to match_array(@call_volumes)
end

When(/^I export the results to CSV$/) do
  @page.export_csv.click
end

Then(/^I am prompted to download a CSV$/) do
  period_string = "#{@start_date.strftime('%Y%m%d')}_#{@end_date.strftime('%Y%m%d')}"
  expect(page.response_headers).to include(
    'Content-Disposition' => "attachment; filename=call_volume_#{period_string}.csv",
    'Content-Type'        => 'text/csv'
  )
end
