class RmRefsRentals < ActiveRecord::Migration[5.2]
  def change
    remove_column :rentals, :customer_id
    remove_column :rentals, :movie_id
  end
end
