class CreateTpCalls < ActiveRecord::Migration[4.2]
  def change
    create_table :tp_calls do |t|
      t.string :uid
      t.datetime :called_at
      t.string :outcome
      t.string :third_party_referring
      t.string :pension_provider
      t.integer :call_duration

      t.timestamps null: false
    end
  end
end
