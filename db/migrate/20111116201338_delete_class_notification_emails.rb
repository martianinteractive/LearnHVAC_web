class DeleteClassNotificationEmails < ActiveRecord::Migration

  def up
    drop_table :class_notification_emails
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
