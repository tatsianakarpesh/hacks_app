# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Cleaning up existing cars..."
Car.destroy_all

TARGET_COUNT = 10_000
BATCH_SIZE = 500

car_data = [
  ['Toyota', 'Camry', 'sedan'],
  ['Honda', 'Civic', 'sedan'],
  ['Ford', 'Mustang', 'sports'],
  ['Tesla', 'Model 3', 'electric'],
  ['BMW', 'X5', 'suv'],
  ['Chevrolet', 'Silverado', 'pickup'],
  ['Audi', 'A4', 'sedan'],
  ['Mercedes-Benz', 'C-Class', 'luxury'],
  ['Volkswagen', 'Golf', 'hatchback'],
  ['Hyundai', 'Tucson', 'suv'],
  ['Kia', 'Sportage', 'suv'],
  ['Mazda', 'CX-5', 'suv'],
  ['Nissan', 'Altima', 'sedan'],
  ['Subaru', 'Outback', 'wagon'],
  ['Jeep', 'Wrangler', 'suv'],
  ['Lexus', 'RX 350', 'suv']
]

colors = ['Red', 'Blue', 'Black', 'White', 'Silver', 'Gray', 'Green']

puts "Creating #{TARGET_COUNT} cars in batches of #{BATCH_SIZE}..."

(0...TARGET_COUNT).each_slice(BATCH_SIZE) do |batch|
  start_id = batch.first + 1
  end_id = batch.last + 1

  cars_data = batch.map do |i|
    make, model, type = car_data.sample
    year = rand(2015..2025)
    color = colors.sample

    # Use car-specific images from CARAPI
    image_url = case type
    when 'sedan'
      "https://cdn.imagin.studio/getimage?customer=img&make=#{make.downcase}&modelFamily=#{model.downcase}&angle=23"
    when 'suv'
      "https://cdn.imagin.studio/getimage?customer=img&make=#{make.downcase}&modelFamily=#{model.downcase}&angle=23"
    when 'sports'
      "https://cdn.imagin.studio/getimage?customer=img&make=#{make.downcase}&modelFamily=#{model.downcase}&angle=23"
    when 'pickup'
      "https://cdn.imagin.studio/getimage?customer=img&make=#{make.downcase}&modelFamily=#{model.downcase}&angle=23"
    when 'luxury'
      "https://cdn.imagin.studio/getimage?customer=img&make=#{make.downcase}&modelFamily=#{model.downcase}&angle=23"
    when 'electric'
      "https://cdn.imagin.studio/getimage?customer=img&make=#{make.downcase}&modelFamily=#{model.downcase}&angle=23"
    when 'hatchback'
      "https://cdn.imagin.studio/getimage?customer=img&make=#{make.downcase}&modelFamily=#{model.downcase}&angle=23"
    when 'wagon'
      "https://cdn.imagin.studio/getimage?customer=img&make=#{make.downcase}&modelFamily=#{model.downcase}&angle=23"
    end

    # Add year and random color to the image URL for variety
    image_url += "&year=#{year}&paintId=#{color.downcase}"

    {
      make: make,
      model: model,
      year: year,
      price: rand(15_000..60_000) + rand.round(2),
      description: "#{color} #{year} #{make} #{model}. Great condition, low mileage. #{rand(10_000..80_000)} miles. ID: #{i+1}",
      image_url: image_url,
      created_at: Time.current,
      updated_at: Time.current
    }
  end

  Car.insert_all!(cars_data)
  puts "Created batch of #{cars_data.size} cars (#{start_id} to #{end_id})"
end

total_count = Car.count
puts "\nSeeding completed!"
puts "Total cars in database: #{total_count}"
puts "Random sample of 5 cars:"
Car.order("RANDOM()").limit(5).each do |car|
  puts "- #{car.year} #{car.make} #{car.model} ($#{car.price})"
  puts "  Image: #{car.image_url}"
end
