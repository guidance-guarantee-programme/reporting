class CreateCostItems < ActiveRecord::Migration
  def change
    create_table :cost_items do |t|
      t.string :name, default: '', null: false
      t.boolean :current, default: true, null: false

      t.timestamps null: false
    end
  end
end
