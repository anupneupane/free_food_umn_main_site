class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.text :description
      t.text :current_main_event

      t.timestamps
    end
  end
end
