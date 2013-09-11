class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name,  :index => true, :null => false, :unique => true

      t.timestamps
    end
  end
end
