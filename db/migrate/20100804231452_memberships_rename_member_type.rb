class MembershipsRenameMemberType < ActiveRecord::Migration
  def self.up
    rename_column :memberships, :member_type, :member_role
  end

  def self.down
    rename_column :memberships, :member_role, :member_type
  end
end
