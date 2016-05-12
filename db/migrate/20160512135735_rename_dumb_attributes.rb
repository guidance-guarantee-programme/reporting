class RenameDumbAttributes < ActiveRecord::Migration
  def change
    rename_column :where_did_you_hears, :where, :heard_from
    rename_column :where_did_you_hears, :where_raw, :heard_from_raw
    rename_column :where_did_you_hears, :where_code, :heard_from_code
  end
end
