class IpAddrInDevice < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :ip_addr, :string, limit: 512, null: false, default: ''
  end
end
