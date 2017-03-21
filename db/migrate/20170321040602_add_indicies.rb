class AddIndicies < ActiveRecord::Migration[5.0]
  def change
    add_index :media_items, :file
    add_index :media_items, :description
    add_index :media_items, :type
  end
end
