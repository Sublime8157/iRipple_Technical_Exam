FactoryBot.define do
  factory :order do
    status       { 'P' }
    total_amount { 0 }
  end
end