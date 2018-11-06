class UpdateAvailInvMoviesToMatchInv < ActiveRecord::Migration[5.2]
  def self.up
    Movie.update_all("inventory_available=inventory")
  end

  def self.down
    # rollback if update does not work
  end
end


