class Lhlog < ActiveRecord::Migration
  def self.up
    create_table :lhlog do |t|
      t.integer  :user_id
      t.integer  :action_id
      t.integer  :value_id
      t.string   :value_string
      t.timestamps
    end
    
    add_index :lhlog, ["user_id"], :name => "index_hits_on_user_id"
  end

  def self.down
    
    remove_index :lhlog, :name => "index_hits_on_user_id"
    drop_table :lhlog
  end
end
