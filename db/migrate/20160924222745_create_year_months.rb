class CreateYearMonths < ActiveRecord::Migration[4.2]
  def change
    create_table :year_months do |t|
      t.string :value
      t.string :short_format
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps null: false
    end


    add_column :appointment_summaries, :year_month_id, :integer, null: false, default: 0

    unless Rails.env.test?
      (-20..20).each do |offset|
        date = Time.zone.today << offset
        YearMonth.find_or_build(year: date.year, month: date.month)
      end

      execute(
        '
          UPDATE appointment_summaries
          SET year_month_id = (SELECT id FROM year_months WHERE value = reporting_month)
        '
      )
    end
  end
end
