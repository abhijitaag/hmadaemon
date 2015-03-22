class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :code
      t.string :hma_string

      t.timestamps null: false
    end
  end
end
