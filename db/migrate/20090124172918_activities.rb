class Activities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.integer  :user_id
      t.integer  :action_id
      t.integer  :value_id
      t.string   :value_string
      t.timestamps
    end
    
    
  end

  def self.down
    drop_table :activities
  end
end
