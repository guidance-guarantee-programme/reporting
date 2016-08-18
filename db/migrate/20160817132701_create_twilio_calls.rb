class CreateTwilioCalls < ActiveRecord::Migration
  def change
    create_table :twilio_calls do |t|
      t.string :uid
      t.datetime :called_at
      t.string :inbound_number
      t.string :outbound_number
      t.integer :call_duration
      t.decimal :cost, precision: 10, scale: 4
      t.string :outcome
      t.string :delivery_partner
      t.string :location_uid
      t.string :location
      t.string :location_postcode
      t.string :booking_location
      t.string :booking_location_postcode

      t.timestamps null: false
    end
  end
end
