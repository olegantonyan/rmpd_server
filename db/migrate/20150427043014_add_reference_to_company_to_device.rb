class AddReferenceToCompanyToDevice < ActiveRecord::Migration
  def change
    change_table :devices do |t|
      t.references :company, index: true
    end
  end
end
