class TwilioNumbersReport
  SINGLE_EMAIL = '([^";@\s\.,]+\.)*[^";@\s\.,]+@([^";@\s\.,]+\.)+[a-z]{2,10}'.freeze

  include ActiveModel::Model

  attr_accessor :email

  validates :email, format: /\A#{SINGLE_EMAIL}(, ?#{SINGLE_EMAIL})*\z/

  def emails
    email.split(/, ?/)
  end
end
