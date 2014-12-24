class AddUserAgentToLog < ActiveRecord::Migration
  def change
    add_column :device_logs, :user_agent, :string
  end
end
