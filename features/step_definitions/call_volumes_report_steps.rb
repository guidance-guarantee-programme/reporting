Given(/^Twilio call data exists for the period "([^"]*)" to "([^"]*)"$/) do |start_date, end_date|
  User.create!(
    name: 'Test user',
    email: 'test@test.com',
    uid: SecureRandom.uuid,
    permissions: ['signin'],
    remotely_signed_out: false,
    disabled: false
  )
  start_date = Date.parse(start_date)
  end_date = Date.parse(end_date)

  (start_date..end_date).each_with_index do |date, i|
    DailyCall.create!(
      source: 'twilio',
      date: date,
      call_volume: i
    )
  end
end

When(/^I view the call volumes report for "([^"]*)"$/) do |reporting_period|
  @reporting_period = reporting_period
  @page = CallVolumesReportPage.new
  @page.load(query: { month: Date.parse(reporting_period).strftime('%Y-%m') })
end

Then(/^I should see daily twilio call volumes$/) do
  twilio_call_volumne = @page.calls.days.map { |day| [day.date.text, day.twilio_volume.text] }

  start_date = Date.parse(@reporting_period)
  expected = (start_date...start_date >> 1).each_with_index.map { |d, i| [d.to_s(:govuk_date), i.to_s] }
  expect(twilio_call_volumne).to eq(expected)
end
