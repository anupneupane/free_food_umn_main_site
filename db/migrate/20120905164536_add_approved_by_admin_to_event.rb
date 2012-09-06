class AddApprovedByAdminToEvent < ActiveRecord::Migration
  def change
    add_column :events, :approved_by_admin, :boolean, :default => false
  end
end
