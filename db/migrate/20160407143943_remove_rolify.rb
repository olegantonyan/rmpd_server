class RemoveRolify < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up {
        drop_table :user_company_memberships_roles
        drop_table :roles
      }

      dir.down {
        # sorry man
      }
    end
  end
end
