JSON.parse(File.read('db/seeds/customers.json')).each do |customer|
  Customer.create!(customer)
end

JSON.parse(File.read('db/seeds/movies.json')).each_with_index do |movie, index|
  movie["inventory_available"] = movie["inventory"]
  unless Movie.create(movie)
    puts "failed to create Movie #{index}: #{movie["title"]}"
  end
end

# Movie.update_all("inventory_available=inventory")

JSON.parse(File.read('db/seeds/rentals.json'), :quirks_mode => true).each do |rental|
  unless Rental.create(rental)
    puts "failed to create rental #{index}: #{rental["movie_id"]}"
  end
end
