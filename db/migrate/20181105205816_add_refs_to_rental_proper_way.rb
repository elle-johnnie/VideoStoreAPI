class AddRefsToRentalProperWay < ActiveRecord::Migration[5.2]
  def change
    add_column :rentals, :customer_id, :integer
    add_column :rentals, :movie_id, :integer
    add_foreign_key :rentals, :customers
    add_foreign_key :rentals, :movies
  end
end
