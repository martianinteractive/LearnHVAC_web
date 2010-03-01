class Weatherfiles < ActiveRecord::Migration
  def self.up
    create_table :weatherfiles do |t|
       t.string :name
       t.text   :description
    end
  end

  def self.down
    drop_table :weatherfiles 
  end
end
