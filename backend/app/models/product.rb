class Product < ApplicationRecord
  has_many :order_items

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[C A], message: "must be 'C' (Created) or 'A' (Active)" }
end

