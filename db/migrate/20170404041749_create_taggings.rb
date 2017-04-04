class CreateTaggings < ActiveRecord::Migration[5.0]
  def change
    create_table :taggings do |t|
      t.references :tag, index: true, foreign_key: true
      t.references :taggable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
