class AddDisplayedNameToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :displayed_name, :string, null: false, default: ""
  end
end
