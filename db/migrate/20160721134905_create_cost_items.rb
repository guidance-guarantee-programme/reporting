class CreateCostItems < ActiveRecord::Migration[4.2]
  def change
    create_table :cost_items do |t|
      t.string :name, default: '', null: false
      t.boolean :current, default: true, null: false

      t.timestamps null: false
    end
  end
end
