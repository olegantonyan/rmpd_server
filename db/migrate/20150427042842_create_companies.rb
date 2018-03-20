class CreateCompanies < ActiveRecord::Migration[4.2]
  def change
    create_table :companies do |t|
      t.string :title

      t.timestamps null: false
    end
  end
end
