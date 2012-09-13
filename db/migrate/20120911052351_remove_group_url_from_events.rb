class RemoveGroupUrlFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :group_url
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
