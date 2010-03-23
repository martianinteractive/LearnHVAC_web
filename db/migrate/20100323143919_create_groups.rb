class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name
      t.string :code
      t.integer :instructor_id

      t.timestamps
    end
    
    add_index :groups, :instructor_id
  end

  def self.down
    remove_index :groups, :instructor_id
    drop_table :groups
  end
end
