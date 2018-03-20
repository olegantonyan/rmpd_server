class AddTitleToNewsItems < ActiveRecord::Migration[4.2]
  def change
    add_column :news_items, :title, :string, limit: 128, null: false, default: ''
  end
end
