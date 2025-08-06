FactoryBot.define do
  factory :order_item do
    order { nil }
    product { nil }
    quality { 1 }
    price { "9.99" }
  end
end
