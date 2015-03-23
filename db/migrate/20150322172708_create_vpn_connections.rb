class CreateVpnConnections < ActiveRecord::Migration
  def change
    create_table :vpn_connections do |t|
      t.references :country
      t.boolean :active

      t.timestamps null: false
    end
  end
end
