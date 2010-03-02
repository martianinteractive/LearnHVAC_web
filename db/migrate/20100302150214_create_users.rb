class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :first_name
      t.string    :last_name
      t.integer   :institution_id
      t.boolean   :active, :default => true
      t.integer   :student_id
      
      #authlogic
      t.string    :email
      t.string    :crypted_password
      t.string    :password_salt
      t.string    :persistence_token
      t.datetime  :last_request_at

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
