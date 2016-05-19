class AddRawFieldToWdyh < ActiveRecord::Migration
  def change
    add_column :where_did_you_hears, :raw_uid, :jsonb
  end
end
