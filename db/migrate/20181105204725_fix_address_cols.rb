class FixAddressCols < ActiveRecord::Migration[5.2]
  def change
    add_column :customers, :city, :string

  end
end
