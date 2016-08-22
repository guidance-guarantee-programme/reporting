class IncreaseCostScale < ActiveRecord::Migration
  def change
    change_column :twilio_calls, :cost, :decimal, precision: 10, scale: 5
  end
end
