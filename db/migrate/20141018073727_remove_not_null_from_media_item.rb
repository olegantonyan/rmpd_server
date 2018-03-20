class RemoveNotNullFromMediaItem < ActiveRecord::Migration[4.2]
  def up
    change_table :media_items do |t|
      t.change :file, :string, null: true
    end
  end

  def down
    change_table :media_items do |t|
      t.change :file, :string, null: false
    end
  end

end
