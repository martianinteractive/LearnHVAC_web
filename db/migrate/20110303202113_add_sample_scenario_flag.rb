class AddSampleScenarioFlag < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :sample, :boolean, :default => false
  end

  def self.down
    remove_column :scenarios, :sample
  end
end
