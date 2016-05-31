class RenameTpToContactCentreInDailyCallVolume < ActiveRecord::Migration
  def change
    rename_column :daily_call_volumes, :tp, :contact_centre
  end
end
