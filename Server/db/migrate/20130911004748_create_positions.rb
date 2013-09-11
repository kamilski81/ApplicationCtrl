class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions,:id => false do |t|
      t.references :user, index: true
      t.references :role, index: true

      t.timestamps
    end
  end
end
