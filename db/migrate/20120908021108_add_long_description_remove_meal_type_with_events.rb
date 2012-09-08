class AddLongDescriptionRemoveMealTypeWithEvents < ActiveRecord::Migration
  def up
    remove_column :events, :meal_type
    add_column :events, :long_description, :text
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
