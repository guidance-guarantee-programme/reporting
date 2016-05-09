class SplitCallVolumesIntoTwoFields < ActiveRecord::Migration
  def up
    add_column :daily_call_volumes, :tp, :integer, default: 0, null: false
    add_column :daily_call_volumes, :twilio, :integer, default: 0, null: false

    add_index :daily_call_volumes, :date, unique: true

    execute(%{UPDATE daily_call_volumes SET twilio = call_volume WHERE source = 'twilio'})
  end

  def down
    remove_column :daily_call_volumes, :tp
    remove_column :daily_call_volumes, :twilio
  end
end
