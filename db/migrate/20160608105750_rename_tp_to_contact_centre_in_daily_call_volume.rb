class RenameTpToContactCentreInDailyCallVolume < ActiveRecord::Migration[4.2]
  def change
    rename_column :daily_call_volumes, :tp, :contact_centre
  end
end
