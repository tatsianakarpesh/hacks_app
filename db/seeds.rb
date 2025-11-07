# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create sample cars
cars_data = [
  {
    make: 'Tesla',
    model: 'Model S',
    year: 2023,
    price: 89990,
    description: 'Electric Luxury Sedan, Pearl White'
  },
  {
    make: 'BMW',
    model: 'M5',
    year: 2023,
    price: 105000,
    description: 'High-performance Luxury Sedan, Black Sapphire'
  },
  {
    make: 'Mercedes-Benz',
    model: 'S-Class',
    year: 2023,
    price: 115000,
    description: 'Ultra-luxury Sedan, Obsidian Black'
  }
]

cars_data.each do |car_data|
  Car.find_or_create_by!(car_data)
end

puts "Sample cars created successfully!"
puts "Cleaning up existing cars..."
Car.destroy_all

TARGET_COUNT = 1_000

# Structured car data with detailed technical specifications
CARS_DATA = {
  'Acura' => {
    'TLX' => {
      description_template: "%{color} %{year} Acura TLX. %{engine_specs}\nEngine: %{engine_type}\nFuel Type: %{fuel_type}\nMileage: %{mileage} miles\nEngine Power: %{engine_power} HP\n\nFeatures: Premium sport sedan with Diamond Pentagon grille, Jewel Eye® LED headlights, and precision handling. %{transmission} transmission with paddle shifters. Includes advanced driver assistance systems and premium audio.",
      price_range: [35_000, 55_000],
      years: (2020..2025),
      engine_specs: {
        types: ['2.0L Turbo I4', '3.0L Turbo V6'],
        powers: ['272', '355'],
        transmission: ['10-speed automatic']
      }
    },
    'MDX' => {
      description_template: "%{color} %{year} Acura MDX. %{engine_specs}\nEngine: %{engine_type}\nFuel Type: %{fuel_type}\nMileage: %{mileage} miles\nEngine Power: %{engine_power} HP\n\nFeatures: Luxury SUV with Super Handling All-Wheel Drive™. %{transmission} transmission. Premium leather interior and advanced safety features. Spacious three-row seating with premium amenities.",
      price_range: [45_000, 65_000],
      years: (2020..2025),
      engine_specs: {
        types: ['3.5L V6', '3.0L Turbo V6'],
        powers: ['290', '355'],
        transmission: ['10-speed automatic']
      }
    }
  },
  'BMW' => {
    '3 Series' => {
      description_template: "%{color} %{year} BMW 3 Series. %{engine_specs}\nEngine: %{engine_type}\nFuel Type: %{fuel_type}\nMileage: %{mileage} miles\nEngine Power: %{engine_power} HP\n\nFeatures: Athletic sport sedan with iconic kidney grille. %{transmission} transmission. Premium interior with latest iDrive system. Includes BMW Live Cockpit Professional and driving assistance features.",
      price_range: [40_000, 65_000],
      years: (2019..2025),
      engine_specs: {
        types: ['2.0L TwinPower Turbo I4', '3.0L TwinPower Turbo I6'],
        powers: ['255', '382'],
        transmission: ['8-speed automatic']
      }
    },
    'X5' => {
      description_template: "%{color} %{year} BMW X5. %{engine_specs}\nEngine: %{engine_type}\nFuel Type: %{fuel_type}\nMileage: %{mileage} miles\nEngine Power: %{engine_power} HP\n\nFeatures: Luxurious SUV with xDrive all-wheel drive. %{transmission} transmission. Spacious interior with panoramic moonroof. Features latest BMW technology and premium Harman Kardon® audio.",
      price_range: [55_000, 85_000],
      years: (2019..2025),
      engine_specs: {
        types: ['3.0L TwinPower Turbo I6', '4.4L TwinPower Turbo V8'],
        powers: ['335', '523'],
        transmission: ['8-speed automatic']
      }
    }
  },
  'Mercedes' => {
    'C-Class' => {
      description_template: "%{color} %{year} Mercedes-Benz C-Class. %{engine_specs}\nEngine: %{engine_type}\nFuel Type: %{fuel_type}\nMileage: %{mileage} miles\nEngine Power: %{engine_power} HP\n\nFeatures: Elegant sedan with sophisticated styling. %{transmission} transmission. Premium materials and advanced driver assistance systems. Includes MBUX infotainment system with voice control.",
      price_range: [42_000, 70_000],
      years: (2019..2025),
      engine_specs: {
        types: ['2.0L Turbo I4', '3.0L Biturbo V6'],
        powers: ['255', '385'],
        transmission: ['9-speed automatic']
      }
    }
  }
}

COLORS = {
  'Alpine White' => 'white',
  'Jet Black' => 'black',
  'Mineral Gray' => 'gray',
  'Carbon Black' => 'black',
  'Mediterranean Blue' => 'blue',
  'Racing Red' => 'red',
  'British Racing Green' => 'green',
  'Sapphire Blue' => 'blue',
  'Pearl White' => 'white'
}

FUEL_TYPES = ['Premium Gasoline', 'Regular Gasoline', 'Diesel', 'Hybrid', 'Electric']

puts "Creating #{TARGET_COUNT} cars with detailed specifications..."

cars_data = TARGET_COUNT.times.map do |i|
  make = CARS_DATA.keys.sample
  model = CARS_DATA[make].keys.sample
  model_data = CARS_DATA[make][model]
  year = model_data[:years].to_a.sample
  color_name, color_code = COLORS.to_a.sample

  # Get random engine specs
  engine_specs = model_data[:engine_specs]
  engine_type = engine_specs[:types].sample
  engine_power = engine_specs[:powers].sample
  transmission = engine_specs[:transmission].sample
  fuel_type = FUEL_TYPES.sample

  # Generate realistic mileage based on year
  max_yearly_mileage = 15_000
  years_old = Time.current.year - year
  mileage = rand(1_000..(max_yearly_mileage * years_old + 1_000))

  # Format mileage with commas
  formatted_mileage = mileage.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse

  # Calculate price based on mileage, year, and model range
  base_price = rand(model_data[:price_range][0]..model_data[:price_range][1])
  mileage_factor = 1 - (mileage.to_f / (max_yearly_mileage * 10))
  year_factor = (year - model_data[:years].first) / 5.0
  price = (base_price * (1 + year_factor) * mileage_factor).round(-3)

  # Create detailed description
  description = model_data[:description_template] % {
    color: color_name,
    year: year,
    engine_specs: "Technical Specifications:",
    engine_type: engine_type,
    fuel_type: fuel_type,
    mileage: formatted_mileage,
    engine_power: engine_power,
    transmission: transmission
  }

  # Generate proper image URL with correct make/model
  image_url = "https://cdn.imagin.studio/getimage?" + [
    "customer=img",
    "make=#{make.downcase}",
    "modelFamily=#{model.downcase.gsub(' ', '-')}",
    "angle=23",
    "year=#{year}",
    "paintId=#{color_code}"
  ].join('&')

  {
    make: make,
    model: model,
    year: year,
    price: price,
    description: description,
    image_url: image_url,
    created_at: Time.current,
    updated_at: Time.current
  }
end

# Insert all cars in batches
Car.insert_all!(cars_data)

total_count = Car.count
puts "\nSeeding completed!"
puts "Total cars in database: #{total_count}"
puts "\nSample of cars created:"
Car.order("RANDOM()").limit(5).each do |car|
  puts "- #{car.year} #{car.make} #{car.model}"
  puts "  #{car.description.split("\n").join("\n  ")}"
  puts "  Price: $#{car.price.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}"
  puts ""
end
