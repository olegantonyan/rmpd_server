class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :title

      t.timestamps null: false
    end
  end
end
