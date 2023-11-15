Given(/^I am logged in as a Pension Wise data analyst$/) do
  create(:user, permissions: %w[signin analyst])
end

Given(/^I am logged in as a Pension Wise user$/) do
  create(:user, permissions: %w[signin])
end
