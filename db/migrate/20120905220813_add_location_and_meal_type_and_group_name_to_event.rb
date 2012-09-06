class AddLocationAndMealTypeAndGroupNameToEvent < ActiveRecord::Migration
  def change
    add_column :events, :location, :string
    add_column :events, :meal_type, :string
    add_column :events, :group_name, :string
  end
end
