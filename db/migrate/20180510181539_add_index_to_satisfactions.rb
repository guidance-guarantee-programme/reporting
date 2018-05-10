class AddIndexToSatisfactions < ActiveRecord::Migration[5.1]
  def change
    add_index :satisfactions, :uid, unique: true
  end
end
