class RemoveRootRoleFromDb < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up {
        execute <<-SQL
        DELETE FROM roles WHERE name = 'root';
        SQL
      }
      dir.down {

      }
    end
  end
end
