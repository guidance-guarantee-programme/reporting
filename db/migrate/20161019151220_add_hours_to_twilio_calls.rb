class AddHoursToTwilioCalls < ActiveRecord::Migration[4.2]
  def change
    add_column :twilio_calls, :hours, :string, limit: 500

    puts <<~AFTER_MIGRATION
      Run to populate 'hours' on existing records.

      rake data_migration:populate_hours_on_twilio_calls
    AFTER_MIGRATION
  end
end
