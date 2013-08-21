class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :name, null: false
      t.string :identifier, null: false
      t.string :key, index: true, null: false
      t.string :app_type, index: true, null: false, default: 'iOS'
      t.string :url, null: false
      t.references :user, index: true, null: false

      t.timestamps
    end
  end
end
