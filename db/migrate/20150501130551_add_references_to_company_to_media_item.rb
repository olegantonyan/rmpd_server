class AddReferencesToCompanyToMediaItem < ActiveRecord::Migration
  def change
    change_table :media_items do |t|
      t.references :company, index: true
    end
  end
end
