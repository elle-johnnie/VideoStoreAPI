class AddInventoryAvailableColToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :inventory_available, :integer
  end
end
