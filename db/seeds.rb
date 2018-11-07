JSON.parse(File.read('db/seeds/customers.json')).each do |customer|
  Customer.create!(customer)
end

JSON.parse(File.read('db/seeds/movies.json')).each do |movie|
  movie["inventory_available"] = movie["inventory"]
  Movie.create!(movie)
end

# Movie.update_all("inventory_available=inventory")
