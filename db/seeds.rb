# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require "csv"

Product.delete_all
Category.delete_all

filename = Rails.root.join("db/products.csv")

puts "Loading in Products from #{filename}"

csv_data = File.read(filename)

products = CSV.parse(csv_data, headers: true, encoding: "utf-8")

products.each do |item|
  category = Category.find_or_create_by(name: item["category"])

  if category && category.valid?
    product = category.products.create(
      title:          item["name"],
      price:          item["price"],
      description:    item["description"],
      stock_quantity: item["stock quantity"]
    )

    puts "Invalid product: #{item['name']}" unless product&.valid?
  else
    puts "Invalid category: #{item['category']} for product #{item['name']}"
  end
end

puts "Created #{Product.count} products"
puts "Created #{Category.count} categories"
