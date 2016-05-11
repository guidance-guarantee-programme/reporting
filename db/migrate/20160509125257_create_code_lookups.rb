class CreateCodeLookups < ActiveRecord::Migration
  def change
    create_table :code_lookups do |t|
      t.string :from
      t.string :to

      t.timestamps null: false
    end

    add_index :code_lookups, :from, unique: true
  end
end
