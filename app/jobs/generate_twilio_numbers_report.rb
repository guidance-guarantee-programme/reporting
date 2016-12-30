require 'twilio_numbers'

class GenerateTwilioNumbersReport < ApplicationJob
  queue_as :default

  def perform(emails)
    twilio_numbers = TwilioNumbers::Report.new.process

    TwilioNumbersReportMailer.report(emails, twilio_numbers.csv).deliver_later
  end
end
