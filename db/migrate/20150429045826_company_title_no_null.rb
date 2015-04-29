class CompanyTitleNoNull < ActiveRecord::Migration
  def up
    change_column :companies, :title, :string, null: false, limit: 1024
  end
  
  def down
    change_column :companies, :title, :string, null: true
  end
end
