require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      product = build(:product)
      expect(product).to be_valid
    end

    it 'is invalid without a name' do
      product = build(:product, name: nil)
      expect(product).not_to be_valid
      expect(product.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without a code' do
      product = build(:product, code: nil)
      expect(product).not_to be_valid
      expect(product.errors[:code]).to include("can't be blank")
    end

    it 'is invalid with a duplicate code' do
      create(:product, code: 'COFFEE')
      product = build(:product, code: 'COFFEE')
      expect(product).not_to be_valid
      expect(product.errors[:code]).to include("has already been taken")
    end

    it 'is invalid with price less than or equal to 0' do
      product = build(:product, price: 0)
      expect(product).not_to be_valid
    end

    it 'is invalid with wrong status' do
      product = build(:product, status: 'X')
      expect(product).not_to be_valid
    end

    it 'is valid with status C' do
      product = build(:product, status: 'C')
      expect(product).to be_valid
    end

    it 'is valid with status A' do
      product = build(:product, status: 'A')
      expect(product).to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:order_items) }
  end
end