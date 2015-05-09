class AddAllowNotifyToUser < ActiveRecord::Migration
  def change
    add_column :users, :allow_notifications, :boolean, default: false, null: false
  end
end
