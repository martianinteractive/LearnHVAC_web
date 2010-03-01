class AppConfigs < ActiveRecord::Migration
  def self.up
    create_table :app_configs do |t|
      t.string   :authentication_source
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :app_configs
  end
end
