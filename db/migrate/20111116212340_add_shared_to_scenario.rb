class AddSharedToScenario < ActiveRecord::Migration
  def change
    add_column :scenarios, :shared, :boolean, :default => false
  end
end
