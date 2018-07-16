class AddMissingIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :tp_calls, :uid, unique: true

    add_index :where_did_you_hears, :uid
  end
end
