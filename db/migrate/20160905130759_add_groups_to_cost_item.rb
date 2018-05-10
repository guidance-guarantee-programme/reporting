class AddGroupsToCostItem < ActiveRecord::Migration[4.2]
  def change
    add_column :cost_items, :web_cost, :boolean, default: false, null: false
    add_column :cost_items, :delivery_partner, :string, default: '', null: false
    add_column :cost_items, :cost_group, :string, default: '', null: false
  end
end
