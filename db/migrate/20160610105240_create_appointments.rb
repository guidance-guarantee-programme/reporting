class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.string :uid, default: '', null: false
      t.datetime :booked_at, null: false
      t.datetime :booking_at, null: false
      t.datetime :transaction_at, null: false
      t.boolean :cancelled, default: false
      t.string :booking_status, default: '', null: false, index: true
      t.string :delivery_partner, default: '', null: false, index: true
      t.integer :version, default: 0, null: false, index: true

      t.timestamps null: false
    end
  end
end
