class AddGroupUrlToEvent < ActiveRecord::Migration
  def change
    add_column :events, :group_url, :string
  end
end
