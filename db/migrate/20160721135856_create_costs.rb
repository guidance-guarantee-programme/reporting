class CreateCosts < ActiveRecord::Migration[4.2]
  def change
    create_table :costs do |t|
      t.references :cost_item, index: true, foreign_key: true
      t.string :month
      t.integer :value_delta, default: 0, null: false
      t.references :user, index: true, foreign_key: true
      t.boolean :forecast, default: false, null: false

      t.timestamps null: false
    end
  end
end
