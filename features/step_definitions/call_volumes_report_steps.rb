Given(/^there are existing daily call volumes for (Twilio|the contact centre)$/) do |source|
  @call_volumes = {}

  @start_date = 7.days.ago.to_date
  @end_date = 1.day.ago.to_date

  (@start_date..@end_date).each do |date|
    DailyCallVolume.create!(
      date: date,
      map_source(source) => @call_volumes[date.to_s(:govuk_date)] = rand(100)
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

Then(/^the total number of calls for (Twilio|the contact centre) within the date range is returned$/) do |source|
  expect(@page.send("total_#{map_source(source)}_calls").text.to_i).to eq(@call_volumes.values.sum)
end

Then(/^a day-by-by breakdown for (Twilio|the contact centre) within the date range is returned$/) do |source|
  call_volumes = @page.days.map { |day| [day.date.text, day.send("#{map_source(source)}_calls").text.to_i] }
  expect(call_volumes).to match_array(@call_volumes)
end

When(/^I export the results to CSV$/) do
  @filename = 'daily_call_volume.csv'
  @page.export_csv.click
end

When(/^I export the twilio calls to CSV$/) do
  @filename = 'twilio_calls.csv'
  @page.export_twilio_calls_csv.click
end

Then(/^I am prompted to download a CSV$/) do
  expect(page.response_headers).to include(
    'Content-Disposition' => "attachment; filename=#{@filename}",
    'Content-Type'        => 'text/csv'
  )
end

module SourceMapHelper
  def map_source(source)
    source == 'Twilio' ? 'twilio' : 'contact_centre'
  end
end

World(SourceMapHelper)
