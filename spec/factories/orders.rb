FactoryBot.define do
  factory :order do
    user { nil }
    total { "9.99" }
    status { "MyString" }
    shipping_address { "MyText" }
  end
end
