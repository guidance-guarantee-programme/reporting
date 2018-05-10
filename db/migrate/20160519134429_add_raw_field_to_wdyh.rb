class AddRawFieldToWdyh < ActiveRecord::Migration[4.2]
  def change
    add_column :where_did_you_hears, :raw_uid, :jsonb
  end
end
