class RemoveNotNullFromMediaItem < ActiveRecord::Migration
  def change
    change_table :media_items do |t|
      t.change :file, :string, null: true
    end
  end
end
