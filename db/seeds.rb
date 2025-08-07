
# Create admin user
admin_user = User.find_or_create_by(email: "admin@matchafusion.com") do |user|
  user.password = "admin123"
  user.password_confirmation = "admin123"
  user.admin = true
end

puts "Created admin user: #{admin_user.email} (admin: #{admin_user.admin?})"

products = [
  {
    name: "Marukyu Koyamaen Isuzu",
    description: "Isuzu matcha has a refreshing aroma, astringent, mellow umami and slightly bitter flavor.",
    price: 25.00,
    active: true,
    stock_quantity: 50,
    image: "isuzu.jpg"
  },
  {
    name: "Marukyu Koyamaen Aorashi",
    description: "Characterized by a refreshing flavor.",
    price: 25.00,
    active: true,
    stock_quantity: 30,
    image: "aorashi.jpg"
  },
  {
    name: "Yamamasa Koyamaen Ogurayama",
    description: "Mild in character with sweet, creamily full-bodied, delicate flavours.",
    price: 20.00,
    active: true,
    stock_quantity: 40,
    image: "ogurayama.jpg"
  },
  {
    name: "Yamamasa Koyamaen Samidori",
    description: "Moderately full-bodied usucha tea rich in fresh, fragrant, green flavours with a mix of slightly astringent, creamy notes and a slightly sweet sensation.",
    price: 20.00,
    active: true,
    stock_quantity: 35,
    image: "samidori.jpg"
  },
  {
    name: "Ippodo Tea Ummon",
    description: "Rich, robust flavor and vibrant, deep emerald green color.",
    price: 30.00,
    active: true,
    stock_quantity: 25,
    image: "ummon.jpg"
  },
  {
    name: "Ippodo Tea Ikuyo",
    description: "Known for its balanced taste and refreshing bitterness.",
    price: 30.00,
    active: true,
    stock_quantity: 20,
    image: "ikuyo.jpg"
  }
]

products.each do |product_attrs|
  Product.find_or_create_by(name: product_attrs[:name]) do |product|
    product.descrption = product_attrs[:description]
    product.price = product_attrs[:price]
    product.active = product_attrs[:active]
    product.stock_quantity = product_attrs[:stock_quantity]
    product.image = product_attrs[:image]
  end
end

puts "Created #{Product.count} products"
