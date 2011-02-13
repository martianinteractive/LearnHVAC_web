class AddRegions < ActiveRecord::Migration
  def self.up
    create_table :regions do |t|
      t.string :value
      t.string :country
    end
    
    add_index :regions, :country
  end

  def self.down
    drop_table :regions
  end
end
