class RemoveMoviesOutCountFromCustomers < ActiveRecord::Migration[5.2]
  def change
    remove_column :customers, :movies_out_count
  end
end
