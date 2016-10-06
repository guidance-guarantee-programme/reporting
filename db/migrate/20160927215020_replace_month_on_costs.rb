class ReplaceMonthOnCosts < ActiveRecord::Migration
  def change
    add_column :costs, :year_month_id, :integer, null: false, default: 0
    add_index :costs, :year_month_id

    unless Rails.env.test?
      execute(
        '
          UPDATE costs
          SET year_month_id = (SELECT id FROM year_months WHERE value = month)
        '
      )
    end
  end
end
