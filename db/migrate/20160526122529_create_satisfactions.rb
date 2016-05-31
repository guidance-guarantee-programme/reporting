class CreateSatisfactions < ActiveRecord::Migration
  def change
    create_table :satisfactions do |t|
      t.datetime :given_at, null: false
      t.string :uid, default: '', null: false
      t.string :delivery_partner, default: '', null: false
      t.string :satisfaction_raw, default: '', null: false
      t.integer :satisfaction, null: false
      t.string :location, default: '', null: false

      t.timestamps null: false
    end
  end
end
