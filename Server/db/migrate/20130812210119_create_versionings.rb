class CreateVersionings < ActiveRecord::Migration
  def change
    create_table :versionings do |t|
      t.string :profile, null: false, default: '1.0.0'
      t.string :build, null: false
      t.integer :status, null: false, default: 0
      t.text :content, :limit => 4294967295
      t.references :app, index: true, null: false

      t.timestamps
    end

    add_index :versionings, [:profile, :build, :app_id], :unique => true
  end
end
