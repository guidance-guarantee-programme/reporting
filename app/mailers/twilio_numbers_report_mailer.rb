class TwilioNumbersReportMailer < ApplicationMailer
  def report(emails, csv)
    attachments['twilio-numbers.csv'] = csv
    mail to: emails, subject: 'Twilio Numbers Report', body: 'Please find report attached'
  end
end
