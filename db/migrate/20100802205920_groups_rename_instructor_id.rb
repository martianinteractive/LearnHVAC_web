class GroupsRenameInstructorId < ActiveRecord::Migration
  def self.up
    rename_column :groups, :instructor_id, :creator_id
  end

  def self.down
    rename_column :groups, :creator_id, :instructor_id
  end
end
