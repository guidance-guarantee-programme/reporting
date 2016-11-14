class AddCallerNumberToTwilioCalls < ActiveRecord::Migration
  def change
    add_column :twilio_calls, :caller_phone_number, :string
  end
end
