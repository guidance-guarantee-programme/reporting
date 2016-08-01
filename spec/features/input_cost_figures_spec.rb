require 'rails_helper'
require Rails.root.join('features/pages/costs_page')

RSpec.describe 'Input financial costs' do
  it 'can create new costs figures for a month' do
    given_cost_items_exist
    when_i_set_costs_for_the_month
    then_costs_for_the_month_have_been_saved
  end

  it 'can update existsing cost figures for a month' do
    given_cost_items_exist
    and_existing_costs_exist_for_the_month
    when_i_update_costs_for_the_month
    then_cost_deltas_for_the_month_have_been_saved
  end

  def given_cost_items_exist
    @user = create(:user, permissions: %w(signin analyst))

    @item_a = CostItem.create!(name: 'Delivery Partner A')
    @item_b = CostItem.create!(name: 'Delivery Partner B')
  end

  def and_existing_costs_exist_for_the_month
    Cost.create!(cost_item: @item_a, value_delta: 100, month: Time.zone.today.strftime('%Y-%m'), user: @user)
    Cost.create!(cost_item: @item_b, value_delta: 1000, month: Time.zone.today.strftime('%Y-%m'), user: @user)
  end

  def when_i_set_costs_for_the_month
    page = CostsPage.new
    page.load

    page.cost_for(@item_a.name).set(1000)
    page.cost_for(@item_b.name).set(750)

    page.save_button.click
  end
  alias_method :when_i_update_costs_for_the_month, :when_i_set_costs_for_the_month

  def then_costs_for_the_month_have_been_saved
    expect(Cost.pluck(:cost_item_id, :value_delta)).to contain_exactly(
      [@item_a.id, 1000],
      [@item_b.id, 750]
    )
  end

  def then_cost_deltas_for_the_month_have_been_saved
    expect(Cost.pluck(:cost_item_id, :value_delta)).to contain_exactly(
      [@item_a.id, 100],
      [@item_a.id, 900],
      [@item_b.id, 1000],
      [@item_b.id, -250]
    )
  end
end
