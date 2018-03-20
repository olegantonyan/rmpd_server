class AddRootToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :root, :boolean, null: false, default: false
    add_index :users, :root

    reversible do |dir|
      dir.up {
        execute <<-SQL
        UPDATE users SET root = 't' WHERE EXISTS (
        SELECT * FROM user_company_memberships
        JOIN user_company_memberships_roles ON user_company_memberships.id = user_company_memberships_roles.user_company_membership_id
        JOIN roles on roles.id = user_company_memberships_roles.role_id
        WHERE roles.name = 'root'
        AND user_company_memberships.user_id = users.id
        );
        DELETE FROM roles WHERE name = 'root';
        SQL
      }
      dir.down {
      }
    end
  end
end
