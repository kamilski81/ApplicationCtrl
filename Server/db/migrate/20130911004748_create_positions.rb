class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions,:id => false do |t|
      t.references :role, index: true
      t.references :user, index: true


      t.timestamps
    end

    add_index :positions, [:role_id, :user_id], :unique => true
  end
end
