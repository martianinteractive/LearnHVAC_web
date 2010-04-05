class UserAddCityAndState < ActiveRecord::Migration
  def self.up
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :country, :string
  end

  def self.down
    remove_column :users, :city
    remove_column :users, :state
    remove_column :users, :country
  end
end
