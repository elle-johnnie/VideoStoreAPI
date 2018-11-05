class AddDefault0ToInventoryAvailableMovies < ActiveRecord::Migration[5.2]
  def change
    change_column :movies, :inventory_available, :integer, default: 0
  end
end
