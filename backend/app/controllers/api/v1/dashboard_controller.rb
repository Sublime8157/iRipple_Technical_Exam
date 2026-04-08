module Api
  module V1
    class DashboardController < ApplicationController
      def index
        orders = Order.all
        products = Product.all

        total_orders_amount = orders.sum(:total_amount)
        total_products_price = products.sum(:price)
        

        render json: {
          orders: orders.as_json,
          products: products.as_json,
          totals: {
            orders_total: total_orders_amount,
            products_total: total_products_price
          }
        }, status: :ok
      end
    end
  end
end