
# Create admin user
admin_user = User.find_or_create_by(email: "admin@matchafusion.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
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

# Create default pages
pages = [
  {
    title: "Frequently Asked Questions",
    slug: "faq",
    content: <<~HTML
      <h3>When do you usually restock?</h3>
      <p>We usually restock every 2 weeks - but this would depend on the shipping and the availability of the matcha.</p>
      
      <h3>How long does shipping take?</h3>
      <p>A week or two</p>
      
      <h3>Do you ship internationally?</h3>
      <p>No. We do not ship internationally. We only ship across Canada for now.</p>
    HTML
  },
  {
    title: "About Us",
    slug: "about",
    content: <<~HTML
      <h2>Welcome to Matcha Fusion</h2>
      <p>We are passionate about bringing you the finest matcha from Japan. Our carefully curated selection includes premium ceremonial grade matcha and traditional accessories to enhance your matcha experience.</p>
      
      <h3>Our Mission</h3>
      <p>To share the authentic taste and tradition of Japanese matcha culture with matcha enthusiasts around the world.</p>
      
      <h3>Quality Promise</h3>
      <p>All our matcha is sourced directly from renowned tea gardens in Japan, ensuring freshness and authenticity in every cup.</p>
    HTML
  },
  {
    title: "Contact Us",
    slug: "contact",
    content: <<~HTML
      <h2>Get in Touch</h2>
      <p>We'd love to hear from you! Whether you have questions about our products or need assistance with your order, our team is here to help.</p>
      
      <h3>Contact Information</h3>
      <p><strong>Email:</strong> info@matchafusion.com</p>
      <p><strong>Phone:</strong> 1-800-MATCHA-1</p>
      
      <h3>Business Hours</h3>
      <p>Monday - Friday: 9:00 AM - 6:00 PM EST<br>
      Saturday: 10:00 AM - 4:00 PM EST<br>
      Sunday: Closed</p>
      
      <h3>Address</h3>
      <p>123 Matcha Street<br>
      Tea City, TC 12345<br>
      Canada</p>
    HTML
  }
]

pages.each do |page_attrs|
  Page.find_or_create_by(slug: page_attrs[:slug]) do |page|
    page.title = page_attrs[:title]
    page.content = page_attrs[:content]
  end
end

puts "Created #{Page.count} pages"
