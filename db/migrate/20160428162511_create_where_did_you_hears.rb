class CreateWhereDidYouHears < ActiveRecord::Migration
  def change
    create_table :where_did_you_hears do |t|
      t.datetime :given_at, null: false
      t.string :delivery_partner, null: false
      t.string :where, null: false, default: ''
      t.string :pension_provider, null: false, default: ''
      t.string :location, null: false, default: ''

      t.timestamps null: false
    end
  end
end
