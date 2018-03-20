class AddAllowNotifyToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :allow_notifications, :boolean, default: false, null: false
  end
end
