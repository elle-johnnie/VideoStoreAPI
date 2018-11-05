class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string :name
      t.datetime :registered_at
      t.string :address
      t.string :state
      t.string :postal_code
      t.string :phone
      t.integer :movies_out_count

      t.timestamps
    end
  end
end
