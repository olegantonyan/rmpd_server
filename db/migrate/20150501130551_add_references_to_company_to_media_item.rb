class AddReferencesToCompanyToMediaItem < ActiveRecord::Migration[4.2]
  def change
    change_table :media_items do |t|
      t.references :company, index: true
    end
  end
end
