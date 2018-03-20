class AddReferenceToCompanyToDevice < ActiveRecord::Migration[4.2]
  def change
    change_table :devices do |t|
      t.references :company, index: true
    end
  end
end
