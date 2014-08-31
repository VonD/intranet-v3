class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :location
      t.boolean :is_test, default: false
      t.date :is_active_from
      t.date :is_active_to

      t.timestamps
    end
  end
end
