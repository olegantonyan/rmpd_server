class RemovePaperTrailVersions < ActiveRecord::Migration[5.2]
  def up
    drop_table :versions
  end

  def down
  end
end
