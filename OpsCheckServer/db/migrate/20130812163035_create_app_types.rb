class CreateAppTypes < ActiveRecord::Migration
  def change
    create_table :app_types do |t|
      t.string :type
      t.string :identifier
      t.timestamps
    end
  end
end
