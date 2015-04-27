class CreateUserCompanyMemberships < ActiveRecord::Migration
  def change
    create_table :user_company_memberships do |t|
      t.string :title
      t.references :user, index: true, foreign_key: true
      t.references :company, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
