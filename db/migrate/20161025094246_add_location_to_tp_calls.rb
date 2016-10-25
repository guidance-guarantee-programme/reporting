class AddLocationToTpCalls < ActiveRecord::Migration
  def change
    add_column :tp_calls, :location, :string, default: ''
  end
end
