class AddRefsToRental < ActiveRecord::Migration[5.2]
  def change
    add_column :rentals, :customer_id, :integer
    add_column :rentals, :movie_id, :integer
  end
end
