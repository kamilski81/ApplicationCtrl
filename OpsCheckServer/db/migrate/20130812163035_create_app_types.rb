class CreateAppTypes < ActiveRecord::Migration
  def change
    create_table :app_types do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
