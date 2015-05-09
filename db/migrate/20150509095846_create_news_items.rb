class CreateNewsItems < ActiveRecord::Migration
  def change
    create_table :news_items do |t|
      t.text :body, null: false, limit: 6000
      t.timestamps null: false
    end
  end
end
