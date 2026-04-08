class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  validates :status, inclusion: { in: %w[P C], message: "must be 'P' (Pending) or 'C' (Completed)" }
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }
end
