json.extract! car, :id, :make, :model, :year, :price, :description, :image_url, :created_at, :updated_at
json.url car_url(car, format: :json)
