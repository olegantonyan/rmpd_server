class AddReferenceToCompanyToDevice < ActiveRecord::Migration
  def change
    change_table :devices do |t|
      t.references :devices, :companies, index: true
    end
  end
end
