class AddCallerNumberToTwilioCalls < ActiveRecord::Migration[4.2]
  def change
    add_column :twilio_calls, :caller_phone_number, :string
  end
end
