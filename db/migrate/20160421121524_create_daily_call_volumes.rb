class CreateDailyCallVolumes < ActiveRecord::Migration
  def change
    create_table :daily_call_volumes do |t|
      t.string :source
      t.date :date
      t.integer :call_volume

      t.timestamps null: false
    end
  end
end
