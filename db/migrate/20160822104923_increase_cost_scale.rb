class IncreaseCostScale < ActiveRecord::Migration[4.2]
  def change
    change_column :twilio_calls, :cost, :decimal, precision: 10, scale: 5
  end
end
