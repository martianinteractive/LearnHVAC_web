class Users < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   :login
      t.string   :hashed_password
      t.string   :first_name
      t.string   :last_name
      t.string   :email
      t.integer  :institution_id
      t.integer  :role_id
      t.string   :student_id
      t.datetime :lastlogin
      t.string   :salt
      t.integer  :lock_version,    :default => 0
      t.boolean  :active,          :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
