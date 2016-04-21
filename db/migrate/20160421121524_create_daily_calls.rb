class CreateDailyCalls < ActiveRecord::Migration
  def change
    create_table :daily_calls do |t|
      t.string :source
      t.date :date
      t.integer :call_volume

      t.timestamps null: false
    end
  end
end
