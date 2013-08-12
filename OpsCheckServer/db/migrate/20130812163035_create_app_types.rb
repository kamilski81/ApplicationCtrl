class CreateAppTypes < ActiveRecord::Migration
  def change
    create_table :app_types do |t|
      t.string :type, null: false
      t.string :identifier, null: false
      t.timestamps
    end
  end
end
