class CompanyTitleNoNull < ActiveRecord::Migration[4.2]
  def up
    change_column :companies, :title, :string, null: false, limit: 1024
  end

  def down
    change_column :companies, :title, :string, null: true
  end
end
