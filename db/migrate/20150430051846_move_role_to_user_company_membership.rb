class MoveRoleToUserCompanyMembership < ActiveRecord::Migration[4.2]
  def up
    drop_table :users_roles

    create_table(:user_company_memberships_roles, :id => false) do |t|
      t.references :user_company_membership
      t.references :role
    end
    add_index(:user_company_memberships_roles, [ :user_company_membership_id, :role_id ], :name => '__ids_index__')

  end

  def down
    drop_table :user_company_memberships_roles

    create_table(:users_roles, :id => false) do |t|
      t.references :user
      t.references :role
    end
    add_index(:users_roles, [ :user_id, :role_id ])
  end
end
