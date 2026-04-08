module Api
  module V1
    class OrdersController < ApplicationController

      # fetch all the orders 
      def index
        orders = Order.includes(order_items: :product)
                .order(id: :desc)
                .page(params[:page])
                .per(params[:per_page] || 10)

        data = orders.map do |order|
          {
            id:           order.id,
            status:       order.status,
            total_amount: order.total_amount,
            created_at:   order.created_at,
            items: order.order_items.map do |item|
              {
                product_id:   item.product_id,
                product_name: item.product.name,
                price:        item.price,
                quantity:     item.quantity,
                subtotal:     item.subtotal
              }
            end
          }
        end
        
        render json: {
          data: data,
          meta: {
            current_page: orders.current_page,
            total_pages:  orders.total_pages,
            total_count:  orders.total_count,
            per_page:     orders.limit_value
          }
        }, status: :ok
      end

      # create new order
      def create
        items_params = params[:items]
        
        if items_params.blank?
          return render json: { error: "Items cannot be empty" }, status: :unprocessable_entity
        end

        ActiveRecord::Base.transaction do # transaction start
          total = 0
          order_items_data = []

          items_params.each do |item|
            product = Product.find_by(id: item[:product_id])

            unless product
              return render json: { error: "Product ID #{item[:product_id]} not found" }, status: :unprocessable_entity
            end

            subtotal = product.price * item[:quantity].to_i
            total   += subtotal

            order_items_data << {
              product:  product,
              quantity: item[:quantity].to_i,
              price:    product.price,
              subtotal: subtotal
            }
          end

          order = Order.new(status: "P", total_amount: total)

          unless order.save
            return render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
          end

          order_items_data.each do |oi|
            order.order_items.create!(
              product:  oi[:product],
              quantity: oi[:quantity],
              price:    oi[:price]
            )
          end

          render json: {
            message: "Order created successfully",
            data: {
              id:           order.id,
              status:       order.status,
              total_amount: order.total_amount.to_f,
              items: order.order_items.map do |i|
                {
                  product_id: i.product_id,
                  quantity:   i.quantity,
                  price:      i.price,
                  subtotal:   i.subtotal
                }
              end
            }
          }, status: :ok
        end
      end

      # PUT /api/v1/orders/:id
      def update
        order = Order.find_by(id: params[:id])

        unless order
          return render json: { error: "Order not found" }, status: :not_found
        end

        if order.update(status: params[:status])
          render json: { message: "Order updated", data: order }, status: :ok
        else
          render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/orders/:id
      def destroy
        order = Order.find_by(id: params[:id])

        unless order
          return render json: { error: "Order not found" }, status: :not_found
        end

        if order.destroy
          render json: { message: "Order deleted successfully" }, status: :ok
        else
          render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
        end
      end
      
    end
  end
end

