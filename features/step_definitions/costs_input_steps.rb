Given(/^cost items exist$/) do
  @user = create(:user, permissions: %w(signin analyst))

  @item_a = CostItem.create!(name: 'Delivery Partner A')
  @item_b = CostItem.create!(name: 'Delivery Partner B')
end

When(/^I set costs for the month$/) do
  page = CostsPage.new
  page.load

  page.cost_for(@item_a.name).set(1000)
  page.cost_for(@item_b.name).set(750)

  page.save_button.click
end

Then(/^costs for the month have been saved$/) do
  expect(Cost.pluck(:cost_item_id, :value_delta)).to contain_exactly(
    [@item_a.id, 1000],
    [@item_b.id, 750]
  )
end

Given(/^existing costs exist for the month$/) do
  Cost.create!(cost_item: @item_a, value_delta: 100, month: Time.zone.today.strftime('%Y-%m'), user: @user)
  Cost.create!(cost_item: @item_b, value_delta: 1000, month: Time.zone.today.strftime('%Y-%m'), user: @user)
end

When(/^I update costs for the month$/) do
  page = CostsPage.new
  page.load

  page.cost_for(@item_a.name).set(1000)
  page.cost_for(@item_b.name).set(750)

  page.save_button.click
end

Then(/^cost deltas for the month have been saved$/) do
  expect(Cost.pluck(:cost_item_id, :value_delta)).to contain_exactly(
    [@item_a.id, 100],
    [@item_a.id, 900],
    [@item_b.id, 1000],
    [@item_b.id, -250]
  )
end
