FactoryBot.define do
  factory :product do
    name   { Faker::Food.dish }
    code   { Faker::Alphanumeric.unique.alpha(number: 6).upcase }
    price  { Faker::Commerce.price(range: 50..500) }
    status { 'C' }
  end
end