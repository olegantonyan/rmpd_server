class ChangeUptimeToPoweredonAt < ActiveRecord::Migration[4.2]

  def up
    rename_column :device_statuses, :uptime, :poweredon_at
  end

  def down
    rename_column :device_statuses, :poweredon_at, :uptime
  end

end
