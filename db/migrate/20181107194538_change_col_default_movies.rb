class ChangeColDefaultMovies < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:movies, :inventory_available, nil)
  end
end
