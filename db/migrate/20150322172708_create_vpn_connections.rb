class CreateVpnConnections < ActiveRecord::Migration
  def change
    create_table :vpn_connections do |t|
      t.country :references
      t.active :boolean

      t.timestamps null: false
    end
  end
end
