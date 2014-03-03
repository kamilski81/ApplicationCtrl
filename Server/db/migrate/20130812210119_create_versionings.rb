class CreateVersionings < ActiveRecord::Migration
  def change
    create_table :versionings do |t|
      t.string :version, null: false
      t.string :build, null: false
      t.string :status, null: false, default: 'WORKING'
      t.text :content, :limit => 4294967295
      t.references :app, index: true, null: false

      t.timestamps
    end

    add_index :versionings, [:version, :build, :app_id], :unique => true
  end
end
