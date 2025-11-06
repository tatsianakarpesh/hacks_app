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

TARGET_COUNT = 1_000

# Extended list of car manufacturers and their models
CARS_DATA = {
  'Audi' => ['A3', 'A4', 'A6', 'Q3', 'Q5', 'Q7', 'RS6', 'e-tron'],
  'BMW' => ['3 Series', '5 Series', 'X3', 'X5', 'M3', 'M5', 'i4', 'iX'],
  'Mercedes' => ['C-Class', 'E-Class', 'S-Class', 'GLC', 'GLE', 'AMG GT', 'EQS'],
  'Volkswagen' => ['Golf', 'Passat', 'Tiguan', 'Atlas', 'ID.4', 'Arteon'],
  'Porsche' => ['911', 'Cayenne', 'Macan', 'Panamera', 'Taycan'],
  'Tesla' => ['Model 3', 'Model S', 'Model X', 'Model Y', 'Cybertruck'],
  'Toyota' => ['Camry', 'Corolla', 'RAV4', 'Highlander', 'Supra', 'Prius'],
  'Honda' => ['Civic', 'Accord', 'CR-V', 'Pilot', 'HR-V'],
  'Ford' => ['Mustang', 'F-150', 'Explorer', 'Bronco', 'Mach-E'],
  'Chevrolet' => ['Camaro', 'Silverado', 'Tahoe', 'Corvette', 'Bolt'],
  'Hyundai' => ['Tucson', 'Santa Fe', 'Elantra', 'Ioniq 5', 'Palisade'],
  'Kia' => ['Sportage', 'Telluride', 'EV6', 'K5', 'Sorento'],
  'Volvo' => ['XC40', 'XC60', 'XC90', 'S60', 'C40'],
  'Mazda' => ['CX-5', 'CX-9', 'Mazda3', 'Mazda6', 'MX-5'],
  'Lexus' => ['RX', 'NX', 'ES', 'IS', 'LC'],
  'Jaguar' => ['F-Pace', 'I-Pace', 'XF', 'F-Type'],
  'Land Rover' => ['Range Rover', 'Defender', 'Discovery', 'Evoque'],
  'Subaru' => ['Outback', 'Forester', 'WRX', 'Crosstrek'],
  'Acura' => ['MDX', 'RDX', 'TLX', 'Integra'],
  'Infiniti' => ['Q50', 'QX50', 'QX60', 'QX80']
}

COLORS = [
  'Alpine White', 'Jet Black', 'Mineral Gray', 'Carbon Black',
  'Sapphire Blue', 'Mediterranean Blue', 'Racing Red', 'Ferrari Red',
  'British Racing Green', 'Emerald Green', 'Sunset Orange', 'Daytona Violet',
  'Silver Metallic', 'Champagne', 'Pearl White', 'Metallic Bronze',
  'Moonstone', 'Nardo Gray', 'Tanzanite Blue', 'Dravit Gray'
]

CURRENT_YEAR = Time.current.year

puts "Creating #{TARGET_COUNT} cars with variety..."

cars_data = TARGET_COUNT.times.map do |i|
  make = CARS_DATA.keys.sample
  model = CARS_DATA[make].sample
  year = rand(2015..CURRENT_YEAR)
  color = COLORS.sample

  # Price logic based on make, year, and model
  base_price = case make
    when 'Porsche', 'Ferrari', 'Lamborghini'
      rand(80_000..200_000)
    when 'BMW', 'Mercedes', 'Audi', 'Tesla'
      rand(45_000..120_000)
    when 'Lexus', 'Volvo', 'Land Rover'
      rand(40_000..90_000)
    else
      rand(25_000..60_000)
  end

  # Adjust price based on year
  year_factor = (year - 2015) / 10.0
  price = (base_price * (1 + year_factor)).round(-3)

  {
    make: make,
    model: model,
    year: year,
    price: price,
    description: "#{color} #{year} #{make} #{model}. Excellent condition with premium features.",
    image_url: "https://cdn.imagin.studio/getimage?customer=img&make=#{make.downcase}&modelFamily=#{model.downcase.gsub(' ', '-')}&angle=23&year=#{year}&paintId=#{color.downcase.gsub(' ', '-')}",
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
  puts "- #{car.year} #{car.make} #{car.model} (#{car.description.split('.').first}) - $#{car.price.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\\1,')}"
end
