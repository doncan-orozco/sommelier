# Clear existing data
puts "Clearing existing data..."
OrderItem.delete_all
Order.delete_all
MenuItem.delete_all
Category.delete_all
AdminUser.delete_all

# Create admin user
puts "Creating admin user..."
admin = AdminUser.create!(
  name: "Admin User",
  email: "admin@lareta.com",
  password: "admin123",
  password_confirmation: "admin123"
)

puts "Created admin user with email: #{admin.email} and password: admin123"

# Create categories
puts "Creating categories..."
categories = [
  { name: "Appetizers", description: "Start your meal with these delicious appetizers", sort_order: 1 },
  { name: "Main Courses", description: "Hearty and satisfying main dishes", sort_order: 2 },
  { name: "Desserts", description: "Sweet treats to end your meal", sort_order: 3 },
  { name: "Beverages", description: "Refreshing drinks and beverages", sort_order: 4 },
  { name: "Salads", description: "Fresh and healthy salad options", sort_order: 5 }
]

category_objects = categories.map do |cat_data|
  Category.create!(cat_data)
end

puts "Created #{category_objects.count} categories"

# Create menu items
puts "Creating menu items..."
menu_items = [
  # Appetizers
  {
    name: "Classic Caesar Salad",
    description: "Crisp romaine lettuce, parmesan cheese, croutons, and our signature Caesar dressing",
    price: 8.99,
    category: category_objects[0]
  },
  {
    name: "Chicken Wings",
    description: "Spicy buffalo wings served with celery sticks and blue cheese dressing",
    price: 12.99,
    category: category_objects[0]
  },
  {
    name: "Mozzarella Sticks",
    description: "Golden fried mozzarella sticks with marinara sauce",
    price: 9.99,
    category: category_objects[0]
  },

  # Main Courses
  {
    name: "Classic Cheeseburger",
    description: "Beef patty with lettuce, tomato, onion, pickles, and cheddar cheese on a sesame bun",
    price: 14.99,
    category: category_objects[1]
  },
  {
    name: "Grilled Chicken Breast",
    description: "Marinated chicken breast with herb seasoning, served with vegetables and rice",
    price: 16.99,
    category: category_objects[1]
  },
  {
    name: "Margherita Pizza",
    description: "Fresh tomato sauce, mozzarella cheese, and basil on thin crust",
    price: 18.99,
    category: category_objects[1]
  },
  {
    name: "Fish and Chips",
    description: "Beer-battered cod with crispy fries and tartar sauce",
    price: 15.99,
    category: category_objects[1]
  },
  {
    name: "Beef Tacos",
    description: "Three soft tacos with seasoned ground beef, lettuce, cheese, and salsa",
    price: 13.99,
    category: category_objects[1]
  },

  # Desserts
  {
    name: "Chocolate Brownie",
    description: "Warm chocolate brownie with vanilla ice cream and chocolate sauce",
    price: 7.99,
    category: category_objects[2]
  },
  {
    name: "Cheesecake",
    description: "New York style cheesecake with berry compote",
    price: 8.99,
    category: category_objects[2]
  },
  {
    name: "Apple Pie",
    description: "Homemade apple pie with cinnamon and vanilla ice cream",
    price: 6.99,
    category: category_objects[2]
  },

  # Beverages
  {
    name: "Coca Cola",
    description: "Classic Coca Cola served ice cold",
    price: 2.99,
    category: category_objects[3]
  },
  {
    name: "Fresh Orange Juice",
    description: "Freshly squeezed orange juice",
    price: 4.99,
    category: category_objects[3]
  },
  {
    name: "Coffee",
    description: "Freshly brewed coffee, served hot",
    price: 3.99,
    category: category_objects[3]
  },
  {
    name: "Iced Tea",
    description: "Refreshing iced tea with lemon",
    price: 3.49,
    category: category_objects[3]
  },

  # Salads
  {
    name: "Greek Salad",
    description: "Mixed greens with feta cheese, olives, tomatoes, and olive oil dressing",
    price: 11.99,
    category: category_objects[4]
  },
  {
    name: "Chicken Cobb Salad",
    description: "Grilled chicken, bacon, eggs, blue cheese, and mixed greens",
    price: 13.99,
    category: category_objects[4]
  },
  {
    name: "Garden Salad",
    description: "Fresh mixed greens with vegetables and your choice of dressing",
    price: 9.99,
    category: category_objects[4]
  }
]

menu_items.each do |item_data|
  MenuItem.create!(item_data)
end

puts "Created #{MenuItem.count} menu items"

# Create some sample orders
puts "Creating sample orders..."

3.times do |i|
  order = Order.create!(
    table_name: "Customer #{i + 1}",
    notes: i == 0 ? "No onions please" : nil,
    status: [ 'pending', 'preparing', 'ready' ].sample
  )

  # Add 1-3 random items to each order
  menu_items_sample = MenuItem.all.sample(rand(1..3))
  menu_items_sample.each do |menu_item|
    OrderItem.create!(
      order: order,
      menu_item: menu_item,
      quantity: rand(1..3),
      unit_price: menu_item.price
    )
  end

  order.calculate_total!
end

puts "Created #{Order.count} sample orders"

puts "\n🎉 Seed data created successfully!"
puts "\nAdmin Login:"
puts "Email: admin@lareta.com"
puts "Password: admin123"
puts "\nYou can now start the Rails server with: rails server"
