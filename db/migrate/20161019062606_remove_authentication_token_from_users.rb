class RemoveAuthenticationTokenFromUsers < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up { remove_column :users, :authentication_token }
      dir.down { add_column :users, :authentication_token, :string }
    end
  end
end
