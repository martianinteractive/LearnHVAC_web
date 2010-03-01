class InstitutionsUsers < ActiveRecord::Migration
  def self.up
    create_table :institutions_users do |t|
      t.integer :user_id
      t.integer :institution_id
      t.timestamps
    end
  end

  def self.down
    drop_table :institutions_users
  end
end
