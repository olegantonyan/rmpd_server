class CreateDevices < ActiveRecord::Migration[4.2]
  def change
    create_table :devices do |t|
      t.string :login
      t.string :name

      t.timestamps null: false
    end
  end
end
