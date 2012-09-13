class RemoveGroupNameFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :group_name
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
