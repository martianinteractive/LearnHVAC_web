class MembershipsExtraColumns < ActiveRecord::Migration
  def self.up
    add_column :memberships, :type, :string
    add_column :memberships, :member_type, :string
    add_column :memberships, :scenario_id, :integer
    
    
    add_index :memberships, :type
    add_index :memberships, :scenario_id
    add_index :memberships, [:member_id, :group_id, :type]
    add_index :memberships, [:member_id, :group_id, :scenario_id, :type]
  end

  def self.down
    remove_index :memberships, [:member_id, :group_id, :scenario_id, :type]
    remove_index :memberships, [:member_id, :group_id, :type]
    remove_index :memberships, :scenario_id
    remove_index :memberships, :type
    
    remove_column :memberships, :scenario_id
    remove_column :memberships, :member_type
    remove_column :memberships, :type
  end
end
