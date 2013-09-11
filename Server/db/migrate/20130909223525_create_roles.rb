class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name, :index => true, :null => false, :unique => true

      t.timestamps
    end

    Role.create!({name: 'admin'})
    Role.create!({name: 'group_admin'})
    Role.create!({name: 'contributor'})

  end
end
