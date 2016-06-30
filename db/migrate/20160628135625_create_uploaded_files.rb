class CreateUploadedFiles < ActiveRecord::Migration
  def change
    create_table :uploaded_files do |t|
      t.string :upload_type, default: '', null: false
      t.string :filename, default: '', null: false
      t.boolean :processed, default: false, null: false
      t.binary :data, null: false

      t.timestamps null: false
    end
  end
end
