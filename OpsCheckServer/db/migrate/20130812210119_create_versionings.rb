class CreateVersionings < ActiveRecord::Migration
  def change
    create_table :versionings do |t|
      t.string :version, null: false
      t.string :build, null: false
      t.integer :status, null: false
      t.references :app, index: true, null: false

      t.timestamps
    end
  end
end
