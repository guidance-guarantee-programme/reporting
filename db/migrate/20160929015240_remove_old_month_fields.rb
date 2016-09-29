class RemoveOldMonthFields < ActiveRecord::Migration
  def change
    remove_column :costs, :month
    remove_column :appointment_summaries, :reporting_month

    add_index :appointment_summaries, :year_month_id
  end
end
