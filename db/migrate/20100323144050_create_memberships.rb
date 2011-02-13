class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.integer :student_id
      t.integer  :group_id
    
      t.timestamps
    end
    
    add_index :memberships, :student_id
    add_index :memberships, :group_id
  end

  def self.down
    remove_index :memberships, :group_id
    remove_index :memberships, :student_id
    
    drop_table :memberships
  end
end
