class CreateMediaItems < ActiveRecord::Migration[4.2]
  def change
    create_table :media_items do |t|
      t.string :file, null: false
      t.string :description, null: false, default: ""
      t.timestamps null: false
    end
  end
end
