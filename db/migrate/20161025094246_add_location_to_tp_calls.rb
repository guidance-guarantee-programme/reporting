class AddLocationToTpCalls < ActiveRecord::Migration[4.2]
  def change
    add_column :tp_calls, :location, :string, default: ''
  end
end
