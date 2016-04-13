class DropDelayedJob < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up { drop_table :delayed_jobs }
      dir.down { }
    end
  end
end
