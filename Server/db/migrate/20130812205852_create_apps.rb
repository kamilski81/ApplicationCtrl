class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :name, null: false
      t.string :identifier, null: false
      t.string :key, null: false
      t.string :app_type, null: false, default: 'iOS'
      t.string :url, null: false
      t.references :team, null: false

      t.timestamps
    end

    add_index :apps, :key, :unique => true
    add_index :apps, :app_type
    add_index :apps, :name
    add_index :apps, :team_id
  end
end
