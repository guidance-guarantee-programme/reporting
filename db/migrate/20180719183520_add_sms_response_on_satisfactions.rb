class AddSmsResponseOnSatisfactions < ActiveRecord::Migration[5.1]
  def change
    add_column :satisfactions, :sms_response, :integer, null: false, default: 0
  end
end
