class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :code
      t.decimal :price
      t.string :status

      t.timestamps
    end
  end
end
