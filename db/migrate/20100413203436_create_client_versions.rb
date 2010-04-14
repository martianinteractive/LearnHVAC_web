class CreateClientVersions < ActiveRecord::Migration
  def self.up
    create_table :client_versions do |t|
      t.string :version
      t.string :url
      t.date :release_date

      t.timestamps
    end
  end

  def self.down
    drop_table :client_versions
  end
end
