class MemembershipsRenameStudentId < ActiveRecord::Migration
  def self.up
    rename_column :memberships, :student_id, :member_id
  end

  def self.down
    rename_column :memberships, :member_id, :student_id
  end
end
