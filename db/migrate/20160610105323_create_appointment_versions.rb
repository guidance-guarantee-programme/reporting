class CreateAppointmentVersions < ActiveRecord::Migration
  def change
    create_table :appointment_versions do |t|
      t.string :uid, default: '', null: false
      t.datetime :booked_at, null: false
      t.datetime :booking_at, null: false
      t.boolean :cancelled, default: false
      t.string :booking_status, default: '', null: false
      t.string :delivery_partner, default: '', null: false
      t.integer :version, default: 0, null: false

      t.timestamps null: false
    end
  end
end
