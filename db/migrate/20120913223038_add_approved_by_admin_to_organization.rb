class AddApprovedByAdminToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :approved_by_admin, :boolean, :default => false
  end
end
