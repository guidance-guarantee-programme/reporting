When(/^I input the costs for the month$/) do
  create(:user, permissions: %w[signin analyst])

  @cita = create(:cost_item, name: 'CITA')
  @cas = create(:cost_item, name: 'CAS')

  page = CostsPage.new
  page.load

  page.cost_for(@cita.name).set(1000)
  page.cost_for(@cas.name).set(750)

  page.save_button.click
end

Then(/^I should be able to the monthly costs$/) do
  page = CostsPage.new
  expect(page).to be_displayed

  expect(page.cost_for(@cita.name).value).to eq('1000')
  expect(page.cost_for(@cas.name).value).to eq('750')
end
