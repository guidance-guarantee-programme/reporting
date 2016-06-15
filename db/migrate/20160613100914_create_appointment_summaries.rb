class CreateAppointmentSummaries < ActiveRecord::Migration
  def change
    create_table :appointment_summaries do |t|
      t.integer :transactions, default: 0, null: false
      t.integer :bookings, default: 0, null: false
      t.integer :completions, default: 0, null: false
      t.string :delivery_partner, default: '', null: false, index: true
      t.string :reporting_month, default: '', null: false, index: true
      t.string :source, default: 'automatic', null: false

      t.timestamps null: false
    end
  end
end
