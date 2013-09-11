class CreateUserGroups < ActiveRecord::Migration
  def change
    create_table :user_groups do |t|
      t.references :group, index: true
      t.references :user, index: true
      t.boolean :confirmed, index: true, default: false

      t.timestamps
    end
    add_index :user_groups, [:group_id, :user_id], :unique => true
  end
end
