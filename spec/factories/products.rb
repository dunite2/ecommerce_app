FactoryBot.define do
  factory :product do
    name { "MyString" }
    descrption { "MyText" }
    price { "9.99" }
    category { nil }
    stock_quantity { 1 }
    active { false }
  end
end
