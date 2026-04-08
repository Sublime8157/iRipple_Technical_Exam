require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'validations' do
    it 'is invalid with quantity less than or equal to 0' do
      item = build(:order_item, quantity: 0)
      expect(item).not_to be_valid
    end

    it 'is invalid with price less than or equal to 0' do
      item = build(:order_item, price: 0)
      expect(item).not_to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:order) }
    it { is_expected.to belong_to(:product) }
  end

  describe '#subtotal' do
    it 'returns quantity multiplied by price' do
      item = build(:order_item, quantity: 3, price: 100)
      expect(item.subtotal).to eq(300)
    end
  end
end