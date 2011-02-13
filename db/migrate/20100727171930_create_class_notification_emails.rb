class CreateClassNotificationEmails < ActiveRecord::Migration
  def self.up
    create_table :class_notification_emails do |t|
      t.integer :class_id
      t.string :recipients
      t.string :subject
      t.text :body

      t.timestamps
    end
    
    add_index :class_notification_emails, :class_id
  end

  def self.down
    remove_index :class_notification_emails, :class_id
    drop_table :class_notification_emails
  end
end
