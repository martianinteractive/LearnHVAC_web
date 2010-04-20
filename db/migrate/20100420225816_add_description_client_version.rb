class AddDescriptionClientVersion < ActiveRecord::Migration
  def self.up
    add_column :client_versions, :description, :text
  end

  def self.down
    remove_column :client_versions, :description
  end
end
