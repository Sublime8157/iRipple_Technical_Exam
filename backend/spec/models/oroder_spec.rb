require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      order = build(:order)
      expect(order).to be_valid
    end

    it 'is invalid with wrong status' do
      order = build(:order, status: 'X')
      expect(order).not_to be_valid
    end

    it 'is invalid with negative total_amount' do
      order = build(:order, total_amount: -1)
      expect(order).not_to be_valid
    end

    it 'is valid with status P' do
      order = build(:order, status: 'P')
      expect(order).to be_valid
    end

    it 'is valid with status C' do
      order = build(:order, status: 'C')
      expect(order).to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:order_items) }
    it { is_expected.to have_many(:products).through(:order_items) }
  end
end