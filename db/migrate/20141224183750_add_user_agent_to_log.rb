class AddUserAgentToLog < ActiveRecord::Migration[4.2]
  def change
    add_column :device_logs, :user_agent, :string
  end
end
