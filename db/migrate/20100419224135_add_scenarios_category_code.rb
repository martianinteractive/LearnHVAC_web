class AddScenariosCategoryCode < ActiveRecord::Migration
  def self.up
    add_column :institutions, :category_code, :integer
  end

  def self.down
    remove_column :institutions, :category_code
  end
end
