class AddBookingReferenceToAppointments < ActiveRecord::Migration[4.2]
  def change
    add_column :appointments, :booking_ref, :string, default: '', null: false
    add_column :appointment_versions, :booking_ref, :string, default: '', null: false

    execute %(UPDATE appointments SET booking_ref = uid WHERE delivery_partner = 'tpas')
    execute %(UPDATE appointment_versions SET booking_ref = uid WHERE delivery_partner = 'tpas')
  end
end
