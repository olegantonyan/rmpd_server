class AddDisplayedNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :displayed_name, :string, null: false, default: ""
  end
end
