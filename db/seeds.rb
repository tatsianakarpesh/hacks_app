# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# This file contains the seed data for the car shop application
puts "Cleaning up existing cars..."
Car.destroy_all

TARGET_COUNT = 1_000

# Structured car data with accurate descriptions and model-specific details
CARS_DATA = {
  'Acura' => {
    'TLX' => {
      description_template: "%{color} %{year} Acura TLX. Sport sedan with premium features including Diamond Pentagon grille, Jewel Eye® LED headlights, and precision handling.",
      price_range: [35_000, 55_000],
      years: (2020..2025)
    },
    'MDX' => {
      description_template: "%{color} %{year} Acura MDX. Luxury SUV featuring Super Handling All-Wheel Drive™, premium leather interior, and advanced safety features.",
      price_range: [45_000, 65_000],
      years: (2020..2025)
    }
  },
  'BMW' => {
    '3 Series' => {
      description_template: "%{color} %{year} BMW 3 Series. Athletic sport sedan with iconic kidney grille, premium interior, and dynamic driving performance.",
      price_range: [40_000, 65_000],
      years: (2019..2025)
    },
    'X5' => {
      description_template: "%{color} %{year} BMW X5. Luxurious SUV featuring xDrive all-wheel drive, spacious interior, and cutting-edge technology.",
      price_range: [55_000, 85_000],
      years: (2019..2025)
    }
  },
  'Mercedes' => {
    'C-Class' => {
      description_template: "%{color} %{year} Mercedes-Benz C-Class. Elegant sedan with sophisticated styling, premium materials, and advanced driver assistance systems.",
      price_range: [42_000, 70_000],
      years: (2019..2025)
    },
    'GLE' => {
      description_template: "%{color} %{year} Mercedes-Benz GLE. Premium SUV with AIRMATIC® suspension, luxurious cabin, and innovative MBUX infotainment.",
      price_range: [58_000, 90_000],
      years: (2020..2025)
    }
  },
  'Audi' => {
    'A4' => {
      description_template: "%{color} %{year} Audi A4. Sophisticated sedan with quattro® all-wheel drive, virtual cockpit, and refined driving dynamics.",
      price_range: [38_000, 60_000],
      years: (2019..2025)
    },
    'Q7' => {
      description_template: "%{color} %{year} Audi Q7. Seven-seat luxury SUV featuring adaptive air suspension, premium Bang & Olufsen® sound, and quattro® capability.",
      price_range: [55_000, 85_000],
      years: (2019..2025)
    }
  },
  'Lexus' => {
    'ES' => {
      description_template: "%{color} %{year} Lexus ES. Refined luxury sedan with whisper-quiet cabin, Mark Levinson® audio, and Lexus Safety System+.",
      price_range: [40_000, 55_000],
      years: (2019..2025)
    },
    'RX' => {
      description_template: "%{color} %{year} Lexus RX. Premium crossover SUV with signature spindle grille, exceptional comfort, and advanced safety features.",
      price_range: [45_000, 65_000],
      years: (2019..2025)
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

puts "Creating #{TARGET_COUNT} cars with accurate details..."

cars_data = TARGET_COUNT.times.map do |i|
  make = CARS_DATA.keys.sample
  model = CARS_DATA[make].keys.sample
  model_data = CARS_DATA[make][model]
  year = model_data[:years].to_a.sample
  color_name, color_code = COLORS.to_a.sample

  # Calculate price based on year and model range
  base_price = rand(model_data[:price_range][0]..model_data[:price_range][1])
  year_factor = (year - model_data[:years].first) / 5.0
  price = (base_price * (1 + year_factor)).round(-3)

  # Create accurate description
  description = model_data[:description_template] % { color: color_name, year: year }

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
  puts "  Description: #{car.description}"
  puts "  Price: $#{car.price.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\\1,')}"
  puts "  Image URL: #{car.image_url}"
  puts ""
end
