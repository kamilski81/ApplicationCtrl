class CreateVersionings < ActiveRecord::Migration
  def change
    create_table :versionings do |t|
      t.string :version, null: false
      t.string :build, null: false
      t.boolean :warning, null: false, default: false
      t.boolean :force_update, null: false, default: false
      t.text :content, :limit => 4294967295
      t.references :app, index: true, null: false

      t.timestamps
    end
  end
end
