AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

require 'faker'
require 'open-uri'

# Clear existing records
Tax.destroy_all
Province.destroy_all
Product.destroy_all
Category.destroy_all

# Create Canadian provinces and their tax rates
provinces = {
  'Alberta' => { gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00 },
  'British Columbia' => { gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0.00 },
  'Manitoba' => { gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0.00 },
  'New Brunswick' => { gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15 },
  'Newfoundland and Labrador' => { gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15 },
  'Nova Scotia' => { gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15 },
  'Ontario' => { gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.13 },
  'Prince Edward Island' => { gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15 },
  'Quebec' => { gst_rate: 0.05, pst_rate: 0.09975, hst_rate: 0.00 },
  'Saskatchewan' => { gst_rate: 0.05, pst_rate: 0.06, hst_rate: 0.00 },
  'Northwest Territories' => { gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00 },
  'Nunavut' => { gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00 },
  'Yukon' => { gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00 }
}

provinces.each do |name, rates|
  province = Province.create!(name: name)
  puts "Created province: #{province.name}"
  Tax.create!(
    province: province,
    gst_rate: rates[:gst_rate],
    pst_rate: rates[:pst_rate],
    hst_rate: rates[:hst_rate]
  )
  puts "Created tax for province: #{province.name}"
end

# Create categories
categories = []
4.times do
  category = Category.create!(
    name: "#{Faker::Food.ingredient} Ham",
    description: Faker::Food.description
  )
  categories << category
  puts "Created category: #{category.name}"
end

# Create products with random images
categories.each do |category|
  20.times do
    product = Product.create!(
      name: Faker::Food.dish,
      description: Faker::Food.description,
      base_price: Faker::Commerce.price(range: 5.0..100.0),
      stock_quantity: Faker::Number.between(from: 10, to: 100),
      category: category
    )
    puts "Created product: #{product.name} in category: #{category.name}"

    # Attach a random image from loremflickr
    file = URI.open("https://loremflickr.com/320/240/ham")
    product.image.attach(io: file, filename: "ham_image.jpg")
    puts "Attached image to product: #{product.name}"
  end
end

puts "Created #{Category.count} categories and #{Product.count} products."
puts "Created #{Province.count} provinces and #{Tax.count} tax records."
