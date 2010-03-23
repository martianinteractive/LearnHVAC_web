class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name
      t.string :code
      t.integer :instructor_id

      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
