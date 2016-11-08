require 'rails_helper'

RSpec.describe TwilioNumbersReport, type: :model do
  it { is_expected.to allow_value('fred.jones@pensionwise.gov.uk').for(:email) }
  it { is_expected.not_to allow_value('fred.jones').for(:email) }
  it { is_expected.not_to allow_value('fred@no-extension').for(:email) }
  it { is_expected.not_to allow_value('  fred@spaced.com  ').for(:email) }
  it { is_expected.not_to allow_value('a  fred@spaced.com').for(:email) }
  it { is_expected.not_to allow_value('a..fred@spaced.com').for(:email) }
  it { is_expected.not_to allow_value('fred@spaced..com').for(:email) }
  it { is_expected.to allow_value('a.fred@spaced.com').for(:email) }
  it { is_expected.not_to allow_value('fr@ed@spaced..com').for(:email) }
  it { is_expected.not_to allow_value('"fred"@spaced.com').for(:email) }
  it { is_expected.not_to allow_value('fred;jones@spaced.com').for(:email) }
  it { is_expected.not_to allow_value('').for(:email) }

  it { is_expected.to allow_value('fred.jones@pensionwise.gov.uk,john.smith@pensionwise.gov.uk').for(:email) }
  it { is_expected.to allow_value('fred.jones@pensionwise.gov.uk, john.smith@pensionwise.gov.uk').for(:email) }
end
